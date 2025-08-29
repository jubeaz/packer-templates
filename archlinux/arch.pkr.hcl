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
        qemu = {
          version = "~> 1"
          source  = "github.com/hashicorp/qemu"
        }
    }
}

build {
  sources = ["source.qemu.archlinux-bios", "source.virtualbox-iso.archlinux-bios", "source.virtualbox-iso.archlinux-uefi"]

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

  provisioner "shell" {
   only            = ["virtualbox-iso.archlinux-uefi", "virtualbox-iso.archlinux-bios"]
   environment_vars =[
       "VBOX_USER=${var.ansible_login}",
   ]
   execute_command = "{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
   script          = "scripts/install-qemu.sh"
  }  

  provisioner "file" {
    source = "srv/files/"
    destination = "/mnt/tmp"
  }

  provisioner "shell" {
    inline = [
      "echo 'Finishing...'",
      "sudo -S /usr/bin/install --mode=0744 --owner=root --group=root /mnt/tmp/80-dhcp.network /mnt/etc/systemd/network/80-dhcp.network",
      "sudo -S /usr/bin/install --mode=0744 --owner=root --group=root /mnt/tmp/resolv.conf /mnt/etc/resolv.conf",
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
#    only            = ["qemu.archlinux"]
#    environment_vars =[
#        "HTTPSRV=${build.PackerHTTPIP}:${build.PackerHTTPPort}"
#    ]
#    execute_command = "{{ .Vars }} sudo -E -S bash '{{ .Path }}'"
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
#      provider_override   = "virtualbox"
      output = "boxes/${local.out_prefix}.box"
    }
  }
}
