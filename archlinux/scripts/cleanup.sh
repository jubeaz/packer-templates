#!/usr/bin/env bash

# stop on errors
set -eu

TARGET_DIR='/mnt'
CONFIG_SCRIPT='/root/packer-cleanup.sh'
CONFIG_SCRIPT_SHORT=`basename "$CONFIG_SCRIPT"`
cat <<-EOF > "${TARGET_DIR}${CONFIG_SCRIPT}"

# Clean the pacman cache.
echo ">>>> cleanup.sh: Cleaning pacman cache.."
/usr/bin/pacman -Scc --noconfirm

# Write zeros to improve virtual disk compaction.
if [[ $WRITE_ZEROS == "true" ]]; then
  echo ">>>> cleanup.sh: Writing zeros to improve virtual disk compaction.."
  zerofile=
  /usr/bin/dd if=/dev/zero of=/tmp/zerofile.XXXXX bs=1M
  /usr/bin/rm -f /tmp/zerofile.XXXXX
  ls /tmp
  /usr/bin/sync
fi

EOF

echo ">>>> cleanup.sh: Entering chroot and configuring system.."
/usr/bin/arch-chroot ${TARGET_DIR} ${CONFIG_SCRIPT}