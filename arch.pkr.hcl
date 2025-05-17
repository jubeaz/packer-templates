packer {
    required_version = ">= 1.12.0"
    required_plugins {
        virtualbox = {
          version = "~> 1.1.1"
          source  = "github.com/hashicorp/virtualbox"
        }
        vagrant = {
          version = ">= 1.0.0"
          source  = "github.com/hashicorp/vagrant"
        }
    }
}

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

build {
  sources = ["source.virtualbox-iso.archlinux-bios", "source.virtualbox-iso.archlinux-uefi"]

provisioner "shell" {
  inline = [
    "echo 'Prevent rebooting...'",
    "sudo -S sed -i '\\|^/usr/bin/systemctl reboot| s|^|#|' /usr/local/bin/install-base.sh",
    "sudo -S sed -i '\\|^/usr/bin/umount -R| s|^|#|' /usr/local/bin/install-base.sh",
    "echo 'Updating system...'",
    "sudo -S bash /usr/local/bin/install-base.sh ${var.hostname}"
  ]
  expect_disconnect = false
}

 provisioner "shell" {
  only            = ["virtualbox-iso.archlinux-uefi", "virtualbox-iso.archlinux-bios"]
  environment_vars =[
      "VBOX_USER=${var.ansible_login}",
  ]
  execute_command = "{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
  script          = "scripts/install-virtualbox.sh"
 }

  provisioner "file" {
    source = "srv/files/"
    destination = "/mnt/tmp"
  }

provisioner "shell" {
  inline = [
    "echo 'Finishing...'",
    "sudo -S /usr/bin/install --mode=0744 --owner=root --group=root /mnt/tmp/80-dhcp.network /mnt/etc/systemd/network/80-dhcp.network",
    "sudo -S /usr/bin/install --mode=0744 --owner=root --group=root /root/hosts /mnt/etc/hosts",
  ]
  expect_disconnect = false
}  
  
provisioner "shell" {
  inline = [
    "echo 'Finish...'",
    "sudo -S /usr/bin/umount -R /mnt",
  ]
  expect_disconnect = false
}

#  provisioner "shell" {
#    environment_vars =[
#        "HTTPSRV=${build.PackerHTTPIP}:${build.PackerHTTPPort}"
#    ]
#    execute_command = "{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
#    only            = ["qemu.archlinux"]
#    script          = "scripts/install-cloudinit.sh"
#  }
#  provisioner "shell" {
#    environment_vars =[
#        "WRITE_ZEROS=${var.write_zeros}"
#    ]
#    execute_command = "{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
#    script          = "scripts/cleanup.sh"
#  }
  post-processors {
    post-processor "vagrant" {
      keep_input_artifact = false
      compression_level   = 9
      provider_override   = "virtualbox"
      output = "boxes/${local.out_prefix}.box"
    }
  }
}
