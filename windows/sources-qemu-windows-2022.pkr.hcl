source "qemu" "windows-2022-bios" {
  output_directory = "${local.output_directory}"
  vm_name          = "${local.vm_name}.qcow2"
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${var.iso_url}"
  accelerator      = "${var.accelerator}"
  boot_wait        = "20s"
  communicator     = "winrm"
  cpus             = "${var.cpu}"
  disk_compression = "true"
  disk_interface   = "virtio"
  disk_size        = "${var.disk_size}"
  floppy_content = {
    "Autounattend.xml" = templatefile(
                    "${path.root}/templates/Autounattend-2022.xml.pkrtpl", 
                    {
                      tpl_admin_password = "${var.admin_password}",
                      tpl_username = "${var.ansible_login}",
                      tpl_password = "${var.ansible_password}",
                      tpl_keymap = "${var.keymap}"
                    }
                  ),
    "Firstboot-Autounattend.xml" = templatefile(
                    "${path.root}/templates/Firstboot-Autounattend.xml.pkrtpl", 
                    {
                      tpl_keymap = "${var.keymap}"
                    }
                  ),                  
  }
  floppy_files     = ["./scripts/0-firstlogin.bat", "./scripts/1-fixnetwork.ps1", "./scripts/70-install-misc.bat", "./scripts/50-enable-winrm.ps1", "./drivers/"]
  #floppy_files     = ["${var.autounattend}", "./scripts/0-firstlogin.bat", "./scripts/1-fixnetwork.ps1", "./scripts/70-install-misc.bat", "./scripts/50-enable-winrm.ps1", "./answer_files/Firstboot/Firstboot-Autounattend.xml", "./drivers/"]
#template_floppy_files = {
#  "Autounattend.xml": templatefile("${path.root}/templates/Autunattend.xml", { product_key = var.product_key })
#}
  format           = "qcow2"
  headless         = "${var.headless}"
  memory           = "${var.ram}"
  net_device       = "virtio-net"
  #qemuargs         = [["-vga", "qxl"], ["-usbdevice", "tablet"]]
  #qemuargs         = [["-usbdevice", "tablet"]]
  shutdown_command = "${var.shutdown_command}"
  winrm_insecure   = "true"
  winrm_timeout    = "30m"
  winrm_use_ssl    = "true"
#  winrm_password   = "vagrant"
#  winrm_username   = "vagrant"
  winrm_password   = "${var.ansible_login}"
  winrm_username   = "${var.ansible_password}"
}
