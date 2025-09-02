source "qemu" "windows-2022-bios" {
  output_directory = "${local.output_directory}"
  vm_name          = "${var.vm_name}.qcow2"
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
                    "${path.root}/unattend/Autounattend-2022-bios.xml.pkrtpl", 
                    {
                      tpl_admin_password = "${var.admin_password}",
                      tpl_username = "${var.ansible_login}",
                      tpl_password = "${var.ansible_password}",
                      tpl_keymap = "${var.keymap}"
                    }
                  ),
    "Firstboot-Autounattend.xml" = templatefile(
                    "${path.root}/unattend/Firstboot-Autounattend.xml.pkrtpl", 
                    {
                      tpl_keymap = "${var.keymap}"
                    }
                  ),           
    "0-firstlogin.bat" = templatefile(
                    "${path.root}/templates/0-firstlogin.bat.pkrtpl", 
                    {
                      tpl_username = "${var.ansible_login}",
                      tpl_drive = "A"
                    }
                  )                   
  }
  floppy_files     = ["${path.root}/scripts/0-firstlogin.bat", "${path.root}/scripts/1-fixnetwork.ps1", "${path.root}/scripts/70-install-misc.bat", "${path.root}/scripts/50-enable-winrm.ps1", "${path.root}/drivers/"]
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
  winrm_password   = "${var.ansible_login}"
  winrm_username   = "${var.ansible_password}"
}


source "qemu" "windows-2022-uefi" {
  output_directory = "${local.output_directory}"
  vm_name          = "${var.vm_name}.qcow2"
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${var.iso_url}"
  accelerator      = "${var.accelerator}"
  boot_wait        = "3s"
  communicator     = "winrm"
  cpus             = "${var.cpu}"
  disk_compression = "true"
  disk_interface   = "virtio"
  #disk_interface   = "ide"
  #use_pflash       = true
  disk_size        = "${var.disk_size}"
  cd_content     = {
    "Autounattend.xml" = templatefile(
                    "${path.root}/unattend/Autounattend-2022-uefi.xml.pkrtpl", 
                    {
                      tpl_admin_password = "${var.admin_password}",
                      tpl_username = "${var.ansible_login}",
                      tpl_password = "${var.ansible_password}",
                      tpl_keymap = "${var.keymap}"
                      tpl_drive = "E" 
                    }
                  ),
    "Firstboot-Autounattend.xml" = templatefile(
                    "${path.root}/unattend/Firstboot-Autounattend.xml.pkrtpl", 
                    {
                      tpl_keymap = "${var.keymap}"
                    }
                  ),           
    "0-firstlogin.bat" = templatefile(
                    "${path.root}/scripts/0-firstlogin.bat.pkrtpl", 
                    {
                      tpl_username = "${var.ansible_login}",
                      tpl_drive = "E"
                    }
                  )           
  }
  cd_files     = ["${path.root}/scripts/1-fixnetwork.ps1", "${path.root}/scripts/70-install-misc.bat", "${path.root}/scripts/50-enable-winrm.ps1", "${path.root}/drivers/"]
	cd_label         = "install"
  format           = "qcow2"
  headless         = "${var.headless}"
  memory           = "${var.ram}"
  net_device       = "virtio-net"
  #qemuargs         = [["-vga", "qxl"], ["-usbdevice", "tablet"]]
  #qemuargs         = [["-usbdevice", "tablet"]]
  #qemuargs         = [
  #  ["-cpu", "host"],
  #  #["-device", "usb-tablet"],
  #  #["-device", "qemu-xhci"],
  #  # Adds a USB 3.0 controller and Places the controller on the PCIe root
  #  #["-device", "qemu-xhci,id=usb,bus=pcie.0,addr=0x8"],
  #  # Attaches the tablet to USB controller usb.0 at port 1
  #  #["-device", "usb-tablet,bus=usb.0,port=1"]
  #]
  shutdown_command = "${var.shutdown_command}"
  winrm_insecure   = "true"
  winrm_timeout    = "30m"
  winrm_use_ssl    = "true"
  winrm_password   = "${var.ansible_login}"
  winrm_username   = "${var.ansible_password}"
  machine_type     = "q35" # As of now, q35 is required for secure boot to be enabled
  #vtpm             = true
  efi_firmware_code = "/usr/share/OVMF/x64/OVMF_CODE.4m.fd"
  efi_firmware_vars = "/usr/share/OVMF/x64/OVMF_VARS.4m.fd"
  #efi_firmware_code = "/usr/share/OVMF/x64/OVMF_CODE.secboot.4m.fd"
  #efi_firmware_code = "${path.root}/ovmf/OVMF_CODE_4M.secboot.fd"
  #efi_firmware_vars = "${path.root}/ovmf/OVMF_VARS_4M.ms.fd" # efivars with MS keys built-in. This is the closest setup to a real machine as the KEK and PK from MS are generally those setup by OEM manufacturers.
  efi_boot          = true
  boot_command = ["<enter>"]
}
