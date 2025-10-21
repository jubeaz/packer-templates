#!/usr/bin/env bash
# https://wiki.archlinux.org/title/QEMU#Preparing_an_Arch_Linux_guest
# stop on errors
set -eu

TARGET_DIR='/mnt'
CONFIG_SCRIPT='/root/packer-qemu.sh'
CONFIG_SCRIPT_SHORT=`basename "$CONFIG_SCRIPT"`
cat <<-EOF > "${TARGET_DIR}${CONFIG_SCRIPT}"

# qemu Guest Additions
# https://wiki.archlinux.org/index.php/qemu/Install_Arch_Linux_as_a_guest
echo ">>>> install-qemu.sh: Installing qemu Guest Additions and NFS utilities.."
/usr/bin/pacman -Sy --noconfirm qemu-guest-agent nfs-utils

echo ">>>> install-qemu.sh: Enabling qemu Guest service.."
/usr/bin/systemctl enable qemu-guest-agent.service
EOF

echo ">>>> install-qemu.sh: Entering chroot and configuring system.."
chmod +x ${TARGET_DIR}/${CONFIG_SCRIPT}
/usr/bin/arch-chroot ${TARGET_DIR} ${CONFIG_SCRIPT}