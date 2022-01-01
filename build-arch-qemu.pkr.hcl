build {
  #sources = ["source.virtualbox-iso.archlinux"]
  sources = ["source.qemu.archlinux"]

provisioner "shell" {
    only            = ["qemu.archlinux"]
    environment_vars =[
        "PACKER_BUILDER_TYPE=${var.packer_build_type}",
        "IS_UEFI=${var.is_uefi}",
        "COUNTRY=${var.country}",
        "ADDITIONAL_PKGS=${var.arch_add_pkgs}",
        "HOSTNAME=${var.hostname}",
        "KEYMAP=${var.keymap}",
        "LANGUAGE=${var.language}",
        "PACKER_PASSWORD=${var.packer_password}",
    ]
    execute_command   = "{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    expect_disconnect = true
    script            = "scripts/install-base.sh"
  }

  provisioner "shell" {
    execute_command = "{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    only            = ["qemu.archlinux"]
    script          = "scripts/install-qemu.sh"
  }

  provisioner "file" {
    source = "srv/cloud/hosts.arch.tmpl"
    destination = "/tmp/hosts.arch.tmpl"
  }
  
  provisioner "shell" {
    environment_vars =[
        "HTTPSRV=${build.PackerHTTPIP}:${build.PackerHTTPPort}"
    ]
    execute_command = "{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    only            = ["qemu.archlinux"]
    script          = "scripts/install-cloudinit.sh"
  }
  provisioner "shell" {
    environment_vars =[
        "WRITE_ZEROS=${var.write_zeros}"
    ]
    execute_command = "{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    script          = "scripts/cleanup.sh"
  }
}
