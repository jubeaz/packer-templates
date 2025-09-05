https://github.com/Orange-Cyberdefense/GOAD/blob/main/packer/vagrant/windows_2022.json
https://github.com/proactivelabs/packer-windows/tree/master
https://wiki.archlinux.org/title/QEMU#Preparing_an_Arch_Linux_guest
https://github.com/StefanScherer/packer-windows
https://github.com/proactivelabs/packer-windows
https://github.com/jakobadam/packer-qemu-templates

# TODO
* secure boot: do as https://github.com/jubeaz/plaber/blob/master/providers/libvirt/README.md

# Packer
* [config](https://developer.hashicorp.com/packer/docs/configure)

Plugins:
```bash
# List installed plugins
packer plugins installed

# Install plugins
packer plugins install github.com/hashicorp/ansible
packer plugins install github.com/hashicorp/qemu
```

# ansible provisioner

* https://developer.hashicorp.com/packer/integrations/hashicorp/ansible/latest/components/provisioner/ansible
* https://github.com/straysheep-dev/packer-configs/blob/main/README.md#packer-and-ansible

# QEMU

## QEMU builder 
* [Qemu Packer builder](https://developer.hashicorp.com/packer/integrations/hashicorp/qemu/latest/components/builder/qemu)
* [straysheep-dev/packer-configs](https://github.com/straysheep-dev/packer-configs/blob/main/README.md)

## UEFI
* [EFI Boot Configuration](https://developer.hashicorp.com/packer/integrations/hashicorp/qemu/latest/components/builder/qemu#efi-boot-configuration)
* [Make UEFI configuration easier](https://github.com/hashicorp/packer-plugin-qemu/issues/97)
* [OVMF](https://github.com/tianocore/tianocore.github.io/wiki/OVMF)



## SPICE

* https://wiki.archlinux.org/title/QEMU#SPICE
* https://www.spice-space.org/