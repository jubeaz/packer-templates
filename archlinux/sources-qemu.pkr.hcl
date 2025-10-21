# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "qemu" "archlinux-bios" {
  output_directory     = "${local.output_directory}"
  vm_name              = "${local.vm_name}.qcow2"
  accelerator          = "kvm"
  format               = "qcow2"
  iso_url              = "${local.iso_url}"
  iso_checksum         = "file:${local.iso_checksum_url}"

  headless             = "${var.headless}"
  #communicator
  ssh_username         = "${var.packer_user}"
  ssh_password         = "${var.packer_password}"
  ssh_timeout          = "${var.ssh_timeout}"

  cpus                 = "${var.cpu}"
  #disk_compression     = "true"
  disk_interface       = "virtio"
  disk_size            = "${var.disk_size}"
  memory               = "${var.ram}"
  net_device           = "virtio-net" # "virtio-net-pci"
#  qemuargs         = [
#  ]  

#  http_directory   = "srv"
  http_content         = {
#     "/cloud/cloud.cfg" = templatefile(
#                     "${path.root}/srv/cloud/cloud.cfg.pkrtpl", 
#                     {
#                       ansible_login = "${var.ansible_login}"
#                       ansible_key = "${var.ansible_key}"
#                       ufw_allow_ssh_ip = "${var.ufw_allow_ssh_ip}"
#                       ntp_pools = "${var.ntp_pools}"
#                       locale = "${var.locale}"
#                     }
#                   )
     "/enable-ssh.sh" = templatefile(
                     "${path.root}/srv/enable-ssh.sh.pkrtpl", 
                     {
                       packer_user = "${var.packer_user}"
                     }
                   )
     "/prepare.sh" = templatefile(
                     "${path.root}/srv/prepare-bios.sh.pkrtpl", 
                     {
                       tpl_ansible_login = "${var.ansible_login}",
                       tpl_ansible_password = "${var.ansible_password}",
                       tpl_disk = "/dev/vda",
                       tpl_vg = "vg0"
                       tpl_extra_pkgs = "${var.arch_add_pkgs}",
                       tpl_countries = "${var.countries}",
                       tpl_keymap = "${var.keymap}",
                       tpl_locale = "${var.locale}",
                       tpl_domain = "${var.domain}",
                       tpl_hostname = "${var.hostname}",
                     }
                   )
     "/hosts" = templatefile(
                     "${path.root}/srv/hosts.pkrtpl", 
                     {
                       tpl_hostname = "${var.hostname}",
                       tpl_domain = "${var.domain}",
                     }
                   )
  }

  shutdown_command     = "${var.shutdown_command}"
  #disable_shutdown     = false
  boot_wait            = "5s"
  boot_command         = [
    "<enter><wait10><wait10><wait10><wait10>",
    "loqdkeys us<enter>",
    "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/enable-ssh.sh<enter><wait2>",
    "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/prepare.sh<enter><wait2>",
    "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/hosts<enter><wait2>",
    "/usr/bin/bash ./enable-ssh.sh ${var.packer_password}<enter>"
  ]
}

source "qemu" "archlinux-uefi" {
  output_directory     = "${local.output_directory}"
  vm_name              = "${local.vm_name}.qcow2"
  accelerator          = "kvm"
  format               = "qcow2"
  iso_url              = "${local.iso_url}"
  iso_checksum         = "file:${local.iso_checksum_url}"

  headless             = "${var.headless}"
  #communicator
  ssh_username         = "${var.packer_user}"
  ssh_password         = "${var.packer_password}"
  ssh_timeout          = "${var.ssh_timeout}"

  cpus                 = "${var.cpu}"
  #disk_compression     = "true"
  disk_interface       = "virtio"
  disk_size            = "${var.disk_size}"
  memory               = "${var.ram}"
  net_device           = "virtio-net" # "virtio-net-pci"
#  qemuargs         = [
#  ]
  machine_type     = "q35" # As of now, q35 is required for secure boot to be enabled
  #vtpm             = true
  efi_boot          = true
  #use_pflash       = true
  efi_firmware_code = "/usr/share/OVMF/x64/OVMF_CODE.4m.fd"
  efi_firmware_vars = "/usr/share/OVMF/x64/OVMF_VARS.4m.fd"
  #efi_firmware_code = "/usr/share/OVMF/x64/OVMF_CODE.secboot.4m.fd"
  #efi_firmware_code = "${path.root}/ovmf/usr/share/OVMF/OVMF_CODE_4M.secboot.fd"
  #efi_firmware_vars = "${path.root}/ovmf/usr/share/OVMF/OVMF_VARS_4M.ms.fd" # efivars with MS keys built-in. This is the closest setup to a real machine as the KEK and PK from MS are generally those setup by OEM manufacturers.


#  http_directory   = "srv"
  http_content         = {
#     "/cloud/cloud.cfg" = templatefile(
#                     "${path.root}/srv/cloud/cloud.cfg.pkrtpl", 
#                     {
#                       ansible_login = "${var.ansible_login}"
#                       ansible_key = "${var.ansible_key}"
#                       ufw_allow_ssh_ip = "${var.ufw_allow_ssh_ip}"
#                       ntp_pools = "${var.ntp_pools}"
#                       locale = "${var.locale}"
#                     }
#                   )
     "/enable-ssh.sh" = templatefile(
                     "${path.root}/srv/enable-ssh.sh.pkrtpl", 
                     {
                       packer_user = "${var.packer_user}"
                     }
                   )
     "/prepare.sh" = templatefile(
                     "${path.root}/srv/prepare-uefi.sh.pkrtpl", 
                     {
                       tpl_ansible_login = "${var.ansible_login}",
                       tpl_ansible_password = "${var.ansible_password}",
                       tpl_disk = "/dev/vda",
                       tpl_vg = "vg0"
                       tpl_extra_pkgs = "${var.arch_add_pkgs}",
                       tpl_countries = "${var.countries}",
                       tpl_keymap = "${var.keymap}",
                       tpl_locale = "${var.locale}",
                       tpl_domain = "${var.domain}",
                       tpl_hostname = "${var.hostname}",
                     }
                   )
     "/hosts" = templatefile(
                     "${path.root}/srv/hosts.pkrtpl", 
                     {
                       tpl_hostname = "${var.hostname}",
                       tpl_domain = "${var.domain}",
                     }
                   )
  }


  shutdown_command     = "${var.shutdown_command}"
  #disable_shutdown     = false
  boot_wait            = "5s"
  boot_command         = [
    "<enter><wait10><wait10><wait10><wait10>",
    "loqdkeys us<enter>",
    "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/enable-ssh.sh<enter><wait2>",
    "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/prepare.sh<enter><wait2>",
    "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/hosts<enter><wait2>",
    "/usr/bin/bash ./enable-ssh.sh ${var.packer_password}<enter>"
  ]
  

}