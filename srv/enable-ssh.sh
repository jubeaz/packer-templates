#!/usr/bin/env bash

PASSWORD=$(/usr/bin/openssl passwd -crypt 'packer')
# packer-specific configuration
/usr/bin/useradd --password ${PASSWORD} --comment 'packer' --create-home --user-group packer
echo 'Defaults env_keep += "SSH_AUTH_SOCK"' > /etc/sudoers.d/packer
echo 'packer ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/packer
/usr/bin/chmod 0440 /etc/sudoers.d/packer
/usr/bin/systemctl start sshd.service
