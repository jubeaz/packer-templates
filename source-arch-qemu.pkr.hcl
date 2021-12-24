# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "qemu" "archlinux" {
  accelerator      = "kvm"
  boot_command     = [
        "<enter><wait10><wait10><wait10>",
        "/usr/bin/curl -O http://{{ .HTTPIP }}:{{ .HTTPPort }}/enable-ssh.sh<enter><wait2>",
        "/usr/bin/bash ./enable-ssh.sh ${var.packer_password}<enter>"
    ]
  boot_wait        = "5s"
  cpus             = "${var.cpu}"
  disk_interface   = "virtio"
  disk_size        = "${var.disk_size}"
  format           = "qcow2"
  headless         = "${var.headless}"
  http_content     = {
     "/cloud/cloud.cfg" = templatefile(
                     "${path.root}/srv/cloud/cloud.cfg.pkrtpl", 
                     {
                       ansible_login = "${var.ansible_login}"
                       ansible_key = "${var.ansible_key}"
                       ufw_allow_ssh_ip = "${var.ufw_allow_ssh_ip}"
                       ntp_pools = "${var.ntp_pools}"
                       locale = "${var.locale}"
                     }
                   )
    "/enable-ssh.sh" = file("srv/enable-ssh.sh")
  }
#  http_directory   = "srv"
  iso_checksum     = "file:${local.iso_checksum_url}"
  iso_url          = "${local.iso_url}"
  memory           = "${var.ram}"
  net_device       = "virtio-net"
  qemu_binary      = "qemu-system-x86_64"
  shutdown_command = "${var.shutdown_command}"
  ssh_password     = "${var.packer_password}"
  ssh_timeout      = "${var.ssh_timeout}"
  ssh_username     = "packer"
  vm_name          = "${local.vm_name}.qcow2"
  output_directory = "${var.qemu_out_dir}/packer/qemu/${local.vm_name}"
}

