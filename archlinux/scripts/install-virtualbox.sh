#!/usr/bin/env bash

# stop on errors
set -eu

TARGET_DIR='/mnt'
CONFIG_SCRIPT='/root/arch-config.sh'
CONFIG_SCRIPT_SHORT=`basename "$CONFIG_SCRIPT"`
cat <<-EOF > "${TARGET_DIR}${CONFIG_SCRIPT}"

# VirtualBox Guest Additions
# https://wiki.archlinux.org/index.php/VirtualBox/Install_Arch_Linux_as_a_guest
echo ">>>> install-virtualbox.sh: Installing VirtualBox Guest Additions and NFS utilities.."
/usr/bin/pacman -Sy --noconfirm virtualbox-guest-utils-nox nfs-utils

echo ">>>> install-virtualbox.sh: Enabling VirtualBox Guest service.."
/usr/bin/systemctl enable vboxservice.service

echo ">>>> install-virtualbox.sh: Enabling RPC Bind service.."
/usr/bin/systemctl enable rpcbind.service

# Add groups for VirtualBox folder sharing
echo ">>>> install-virtualbox.sh: Enabling VirtualBox Shared Folders.."
/usr/bin/usermod --append --groups $VBOX_USER,vboxsf $VBOX_USER
EOF

echo ">>>> install-virtualbox.sh: Entering chroot and configuring system.."
/usr/bin/arch-chroot ${TARGET_DIR} ${CONFIG_SCRIPT}