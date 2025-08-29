# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "qemu" "archlinux-bios" {
  output_directory     = "${local.output_directory}"
  vm_name              = "${local.vm_name}.qcow2"
  iso_url              = "${local.iso_url}"
  iso_checksum         = "file:${local.iso_checksum_url}"

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

  ssh_username         = "${var.packer_user}"
  ssh_password         = "${var.packer_password}"
  ssh_timeout          = "${var.ssh_timeout}"

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
  
  cpus             = "${var.cpu}"
  memory           = "${var.ram}"
  disk_interface   = "virtio"
  disk_size        = "${var.disk_size}"
  format           = "qcow2"
  net_device       = "virtio-net" # "virtio-net-pci"
#  firmware         = "UEFI"

  #machine_type     = "q35"
  #qemu_binary      = "qemu-system-x86_64"
  accelerator      = "kvm"
#  qemuargs         = [
#    [ "-bios", "/usr/share/OVMF/x64/OVMF.fd" ],
#    [ "-device", "virtio-blk-pci,drive=drive0,bootindex=0" ],
#    [ "-device", "virtio-blk-pci,drive=cdrom0,bootindex=1" ],
#    [ "-drive", "if=pflash,format=raw,readonly,file=/usr/share/OVMF/OVMF_CODE.secboot.fd" ],
#    [ "-drive", "if=pflash,format=raw,readonly,file=/usr/share/OVMF/OVMF_VARS.fd" ],
#    [ "-drive", "if=none,file=output/disk.raw,cache=writeback,discard=ignore,format=raw,id=drive0" ],
#    [ "-drive", "if=none,file=packer_cache/a4672833d0d89d9d9953d44436c44a32e50994ed.iso,media=cdrom,id=cdrom0" ],
#    [ "-boot", "order=c,once=d,menu=on,strict=on" ]
#  ]

  headless         = "${var.headless}"
#  http_directory   = "srv"
}