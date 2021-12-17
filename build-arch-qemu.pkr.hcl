build {
  #sources = ["source.virtualbox-iso.archlinux"]
  sources = ["source.qemu.archlinux"]

provisioner "shell" {
    only            = ["qemu.archlinux"]
    environment_vars =[
       "IS_UEFI=${var.is_uefi}",
       "COUNTRY=${var.country}",
       "ADDITIONAL_PKGS=${var.arch_add_pkgs}",
       "WITH_VAGRANT=${var.with_vagrant}",
       "ANSIBLE_IN_LOGIN=${var.ansible_login}", 
       "ANSIBLE_IN_PASSWORD=${var.ansible_password}", 
       "ROOT_IN_PASSWORD=${var.root_password}",
       "PACKER_IN_PASSWORD=${var.packer_password}"
    ]
    execute_command   = "{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    expect_disconnect = true
    script            = "scripts/install-base.sh"
    # script            = "scripts/test.sh"
  }

  provisioner "shell" {
    execute_command = "{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    only            = ["qemu.archlinux"]
    script          = "scripts/install-qemu.sh"
  }

  provisioner "shell" {
    environment_vars =[
        "WRITE_ZEROS=${var.write_zeros}"
    ]
    execute_command = "{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    script          = "scripts/cleanup.sh"
  }

  post-processor "vagrant" {
    keep_input_artifact = true
    output              = "output/packer_arch_<no value>-${local.version}.01.box"
  }
}
