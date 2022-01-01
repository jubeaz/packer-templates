#!/usr/bin/env bash

# stop on errors
set -eu

IS_UEFI=${IS_UEFI:-false}
WITH_WIFI=${WITH_WIFI:-false}
HOSTNAME=${HOSTNAME:-'arch'}
KEYMAP=${KEYMAP:-'fr-latin1'}
LANGUAGE=${LANGUAGE:-'en_US.UTF-8'}
COUNTRY=${COUNTRY:-FR}
ADDITIONAL_PKGS=${ADDITIONAL_PKGS:-""}
PACKER_PASSWORD=${PACKER_PASSWORD:-"password"}
UEFI_PART=${UEFI_PART:-FR}


echo ">>>>>>>>>>>>>>>> IS_UEFI: ${IS_UEFI}"
echo ">>>>>>>>>>>>>>>> COUNTRY: ${COUNTRY}"
echo ">>>>>>>>>>>>>>>> ADDITIONAL_PKGS: ${ADDITIONAL_PKGS}"
echo ">>>>>>>>>>>>>>>> PACKER_PASSWORD: ${PACKER_PASSWORD}"
echo ">>>>>>>>>>>>>>>> ${HOSTNAME}"
echo ">>>>>>>>>>>>>>>> ${KEYMAP}"
echo ">>>>>>>>>>>>>>>> ${LANGUAGE}"
echo ">>>>>>>>>>>>>>>> ${PACKER_BUILDER_TYPE}"


TIMEZONE='UTC'
CONFIG_SCRIPT='/usr/local/bin/arch-config.sh'
TARGET_DIR='/mnt'

if [ $PACKER_BUILDER_TYPE == "qemu" ]; then
  DISK='/dev/vda'
else
  DISK='/dev/sda'
fi

ROOT_PARTITION="${DISK}1"

MIRRORLIST="https://archlinux.org/mirrorlist/?country=${COUNTRY}&protocol=http&protocol=https&ip_version=4&use_mirror_status=on"

# #######################################
# 
# DISK MANAGEMENT
#
# #######################################

if [ "${IS_UEFI}" != "false" ] ; then
    echo ">>>> install-base.sh: Clearing partition table on ${DISK}.."
    /usr/bin/sgdisk --zap ${DISK}

    echo ">>>> install-base.sh: Destroying magic strings and signatures on ${DISK}.."
    /usr/bin/dd if=/dev/zero of=${DISK} bs=512 count=2048
    /usr/bin/wipefs --all ${DISK}

    echo ">>>> install-base.sh: Creating /root partition on ${DISK}.."
    /usr/bin/sgdisk --new=1:0:0 ${DISK}

    echo ">>>> install-base.sh: Setting ${DISK} bootable.."
    /usr/bin/sgdisk ${DISK} --attributes=1:set:2
else
    echo ">>>> install-base.sh: Setting ${DISK} minimum partition"
    sfdisk --force ${DISK}  << PARTITION
label: dos
device: ${DISK}
unit: sectors
sector-size: 512

/dev/sda1 : start= 2048, size= 1, type=83, bootable

PARTITION

    echo ">>>> install-base.sh: Setting ${DISK} extend partition to max disk"
    parted ${DISK} resizepart 1 100%
fi

echo ">>>> install-base.sh: Creating /root filesystem (ext4).."
/usr/bin/mkfs.ext4 -O ^64bit -F -m 0 -q -L root ${ROOT_PARTITION}

echo ">>>> install-base.sh: Mounting ${ROOT_PARTITION} to ${TARGET_DIR}.."
/usr/bin/mount -o noatime,errors=remount-ro ${ROOT_PARTITION} ${TARGET_DIR}

# #######################################
# 
# 
#
# #######################################

echo ">>>> install-base.sh: Setting pacman ${COUNTRY} mirrors.."
curl -s "$MIRRORLIST" |  sed 's/^#Server/Server/' > /etc/pacman.d/mirrorlist

echo ">>>> install-base.sh: Bootstrapping the base installation.."
/usr/bin/pacstrap ${TARGET_DIR} base base-devel linux-lts lvm2 linux-firmware

echo ">>>> install-base.sh: Generating the filesystem table.."
/usr/bin/genfstab -p ${TARGET_DIR} >> "${TARGET_DIR}/etc/fstab"

echo ">>>> install-base.sh: Generating the system configuration script.."
/usr/bin/install --mode=0755 /dev/null "${TARGET_DIR}${CONFIG_SCRIPT}"


# #######################################
# 
# 
#
# #######################################

CONFIG_SCRIPT_SHORT=`basename "$CONFIG_SCRIPT"`
cat <<-EOF > "${TARGET_DIR}${CONFIG_SCRIPT}"  
  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Configuring hostname, timezone, and keymap.."
  echo '${HOSTNAME}' > /etc/hostname
  /usr/bin/ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
  echo 'KEYMAP=${KEYMAP}' > /etc/vconsole.conf

  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Configuring locale.."
  /usr/bin/sed -i 's/#${LANGUAGE}/${LANGUAGE}/' /etc/locale.gen
  /usr/bin/locale-gen

  echo ">>>> ${CONFIG_SCRIPT_SHORT}: add lvm2 for initramfs.."
  /usr/bin/sed -i 's/block filesystems/block lvm2 filesystems/' /etc/mkinitcpio.conf

  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Creating initramfs.."
  /usr/bin/mkinitcpio -p linux-lts

# #######################################
# packages
# #######################################

  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Installing basic packages."
  pacman -S --noconfirm gptfdisk
  pacman -S --noconfirm openssh
  pacman -S --noconfirm rsync
  pacman -S --noconfirm netplan
  pacman -S --noconfirm dhcpcd
  pacman -S --noconfirm ufw
  pacman -S --noconfirm apparmor
  pacman -S --noconfirm ${ADDITIONAL_PKGS}
  if [ "${IS_UEFI}" != "false" ] ; then
    echo ">>>> ${CONFIG_SCRIPT_SHORT}: Insatll grub EFI packages"
    pacman -S --noconfirm grub efibootmgr dosfstools os-prober mtools
  else
    echo ">>>> ${CONFIG_SCRIPT_SHORT}: Install grub bios packages"
    pacman -S --noconfirm grub dosfstools os-prober mtools
  fi
  if [ "${WITH_WIFI}" == "true" ] ; then
    echo ">>>> ${CONFIG_SCRIPT_SHORT}: Install wifi packages"
    pacman -S --noconfirm iwd
    pacman -S --noconfirm wireless_tools
  fi

# #######################################
# network
# #######################################
  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Configuring network.."
  # Disable systemd Predictable Network Interface Names and revert to traditional interface names
  # https://wiki.archlinux.org/index.php/Network_configuration#Revert_to_traditional_interface_names
  /usr/bin/ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules

  if [ "${WITH_WIFI}" == "true" ] ; then
    echo ">>>> ${CONFIG_SCRIPT_SHORT}: enable iwd for wifi"
    systemctl enable iwd
  fi
  
  echo ">>>> ${CONFIG_SCRIPT_SHORT}: set netplan config"
  mkdir "/etc/netplan"
  echo "network:" > /etc/netplan/network.yaml
  echo "  version: 2" >> /etc/netplan/network.yaml
  echo "  renderer: networkd" >> /etc/netplan/network.yaml
  echo "  ethernets:" >> /etc/netplan/network.yaml
  echo "    eth0:" >> /etc/netplan/network.yaml
  echo "      dhcp4: true" >> /etc/netplan/network.yaml

  echo ">>>> ${CONFIG_SCRIPT_SHORT}: apply netplan config "
  netplan generate
  netplan appy
  
  echo ">>>> ${CONFIG_SCRIPT_SHORT}: enable networked and resolved"
  /usr/bin/systemctl enable systemd-networkd
  /usr/bin/systemctl enable systemd-resolved

# #######################################
# sshd
# #######################################

  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Configuring sshd.."
  /usr/bin/sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
  /usr/bin/systemctl enable sshd.service

  # Workaround for https://bugs.archlinux.org/task/58355 which prevents sshd to accept connections after reboot
  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Adding workaround for sshd connection issue after reboot.."
  /usr/bin/pacman -S --noconfirm rng-tools
  /usr/bin/systemctl enable rngd


# #######################################
# Packer user
# #######################################

  # packer-specific configuration
  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Creating packer user.."
  /usr/bin/useradd --comment 'Packer' --create-home --user-group packer
  echo "packer:$PACKER_PASSWORD" | /usr/bin/chpasswd
  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Configuring sudo.."
  echo 'Defaults env_keep += "SSH_AUTH_SOCK"' > /etc/sudoers.d/packer
  echo 'packer ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/packer
  /usr/bin/chmod 0440 /etc/sudoers.d/packer


# #######################################
# grub
# #######################################

  # allways run GRUB_CMDLINE_LINUX 
  echo ">>>> ${CONFIG_SCRIPT_SHORT}: setting grub kernel boot params"
  /usr/bin/sed -i  's/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"/' /etc/default/grub

  # do not run in recovery GRUB_CMDLINE_LINUX_DEFAULT
  /usr/bin/sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 ipv6.dsiable=1 lsm=landlock,lockdown,yama,apparmor,bpf"/' /etc/default/grub
  #/usr/bin/sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash ipv6.dsiable=1 lsm=landlock,lockdown,yama,apparmor,bpf"/' /etc/default/grub


  if [ "${IS_UEFI}" != "false" ] ; then
    echo ">>>> ${CONFIG_SCRIPT_SHORT}: Installing UEFI grub"
    mkdir -p /boot/EFI
    mount ${UEFI_PART} /boot/EFI
    grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
    mkdir -p /boot/grub/locale
    cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
    grub-mkconfig -o /boot/grub/grub.cfg
  else
    echo ">>>> ${CONFIG_SCRIPT_SHORT}: Installing BIOS grub"
    grub-install --target=i386-pc --recheck ${DISK} 
    # mkdir /boot/grub/locale
    cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
    grub-mkconfig -o /boot/grub/grub.cfg
  fi
  
# #######################################
# 
# #######################################

  echo ">>>> ${CONFIG_SCRIPT_SHORT}: Cleaning up.."
  /usr/bin/pacman -Rcns --noconfirm gptfdisk
EOF

echo ">>>> install-base.sh: Entering chroot and configuring system.."
/usr/bin/arch-chroot ${TARGET_DIR} ${CONFIG_SCRIPT}
rm "${TARGET_DIR}${CONFIG_SCRIPT}"

echo ">>>> install-base.sh: Completing installation.."
/usr/bin/sleep 3
/usr/bin/umount ${TARGET_DIR}
# Turning network interfaces down to make sure SSH session was dropped on host.
# More info at: https://www.packer.io/docs/provisioners/shell.html#handling-reboots
#echo '==> Turning down network interfaces and rebooting'
# for i in $(/usr/bin/netstat -i | /usr/bin/tail +3 | /usr/bin/awk '{print $1}'); do /usr/bin/ip link set ${i} down; done
/usr/bin/systemctl reboot
echo ">>>> install-base.sh: Installation complete!"
echo ">>>>>>>>>>>>>>>>>> DONE >>>>>>>>>>>>>>>>>>>>"
