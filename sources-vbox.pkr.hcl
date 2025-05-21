
source "virtualbox-iso" "archlinux-uefi" {
  output_directory     = "${var.template_name}-${var.build_type}-${local.version}"
  guest_os_type        = "ArchLinux_64"
  iso_url              = "${local.iso_url}"
  iso_checksum         = "file:${local.iso_checksum_url}"
  ssh_username         = "${var.packer_user}"
  ssh_password         = "${var.packer_password}"
  ssh_timeout          = "${var.ssh_timeout}"
#  shutdown_command     = "${var.shutdown_command}"
  shutdown_command     = ""
  disable_shutdown     = false
  boot_command         = [
  "<enter><wait10><wait10><wait10><wait10>",
  "loqdkeys us<enter>",
  "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/enable-ssh.sh<enter><wait2>",
  "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/prepare.sh<enter><wait2>",
  "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/hosts<enter><wait2>",
  "/usr/bin/bash ./enable-ssh.sh ${var.packer_password}<enter>"
  ]
  boot_wait            = "5s"
  firmware             = "${var.build_type}"
#  vboxmanage = [
#       [ "modifyvm", "{{.Name}}", "--firmware", "EFI" ],
#       [ "modifyvm", "{{.Name}}", "--firmware", "efi64" ],
#       [ "modifyvm", "{{.Name}}", "--firmware", "inituefivarstore" ],
#       [ "modifyvm", "{{.Name}}", "--firmware", "enrollorclpk" ],
#       [ "modifyvm", "{{.Name}}", "--firmware", "enrollmssignatures" ],
#  ]
  cpus                 = "${var.cpu}"
  disk_size            = "${var.disk_size}"
  hard_drive_interface = "sata"
  memory               = "${var.ram}"
  guest_additions_mode = "disable"
  headless             = "${var.headless}"
  #http_directory       = "srv"
  vm_name              = "${var.template_name}-${var.build_type}"
  http_content     = {
#    "/enable-ssh.sh" = file("srv/enable-ssh.sh")
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
                       tpl_disk = "/dev/sda",
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
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--natpf1", "guestssh,tcp,,2222,,22"]
  ]
}

source "virtualbox-iso" "archlinux-bios" {
  output_directory     = "${var.template_name}-${var.build_type}-${local.version}"
  guest_os_type        = "ArchLinux_64"
  iso_url              = "${local.iso_url}"
  iso_checksum         = "file:${local.iso_checksum_url}"
  ssh_username         = "${var.packer_user}"
  ssh_password         = "${var.packer_password}"
  ssh_timeout          = "${var.ssh_timeout}"
#  shutdown_command     = "${var.shutdown_command}"
  shutdown_command     = ""
  disable_shutdown     = false
  boot_command         = [
  "<enter><wait10><wait10><wait10><wait10>",
  "loqdkeys us<enter>",
  "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/enable-ssh.sh<enter><wait2>",
  "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/prepare.sh<enter><wait2>",
  "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/hosts<enter><wait2>",
  "/usr/bin/bash ./enable-ssh.sh ${var.packer_password}<enter>"
  ]
  boot_wait            = "5s"
  firmware             = "${var.build_type}"
  cpus                 = "${var.cpu}"
  disk_size            = "${var.disk_size}"
  hard_drive_interface = "sata"
  memory               = "${var.ram}"
  guest_additions_mode = "disable"
  headless             = "${var.headless}"
  #http_directory       = "srv"
  vm_name              = "${var.template_name}-${var.build_type}"
  http_content     = {
#    "/enable-ssh.sh" = file("srv/enable-ssh.sh")
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
                       tpl_disk = "/dev/sda",
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
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--natpf1", "guestssh,tcp,,2222,,22"]
  ]
}