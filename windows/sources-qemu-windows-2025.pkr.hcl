source "qemu" "windows-2025-bios" {
  output_directory = "${local.output_directory}"
  vm_name          = "${var.vm_name}.qcow2"
  accelerator      = "${var.accelerator}"
  format           = "qcow2"
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${var.iso_url}"

  headless         = "${var.headless}"
  communicator     = "winrm"
  winrm_insecure   = "true"
  winrm_timeout    = "30m"
  winrm_use_ssl    = "true"
  winrm_password   = "${var.ansible_login}"
  winrm_username   = "${var.ansible_password}"

  cpus             = "${var.cpu}"
  disk_compression = "true"
  disk_interface   = "virtio"
  disk_size        = "${var.disk_size}"
  memory           = "${var.ram}"
  net_device       = "virtio-net"
  #qemuargs         = [["-vga", "qxl"], ["-usbdevice", "tablet"]]
  #qemuargs         = [["-usbdevice", "tablet"]]

  floppy_content = {
    "Autounattend.xml" = templatefile(
                    "${path.root}/unattend/Autounattend-2025-bios.xml.pkrtpl", 
                    {
                      tpl_admin_password = "${var.admin_password}",
                      tpl_username = "${var.ansible_login}",
                      tpl_password = "${var.ansible_password}",
                      tpl_keymap = "${var.keymap}",
                      tpl_timezone = "${var.timezone}"
                    }
                  ),
    "Firstboot-Autounattend.xml" = templatefile(
                    "${path.root}/unattend/Firstboot-Autounattend.xml.pkrtpl", 
                    {
                      tpl_keymap = "${var.keymap}",
                      tpl_timezone = "${var.timezone}"
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
  floppy_files     = ["${path.root}/scripts/0-firstlogin.bat", "${path.root}/scripts/1-fixnetwork.ps1", "${path.root}/scripts/70-install-misc.bat", "${path.root}/scripts/50-enable-winrm.ps1", "${path.root}/drivers/", "${path.root}/binaries/virtio-win-guest-tools.exe"]

  shutdown_command = "${var.shutdown_command}"
  boot_wait        = "20s"
}


source "qemu" "windows-2025-uefi" {
  output_directory = "${local.output_directory}"
  vm_name          = "${var.vm_name}.qcow2"
  accelerator      = "${var.accelerator}"
  format           = "qcow2"
  iso_path         = "${var.iso_path}"
  #iso_checksum     = "${var.iso_checksum}"
  #iso_url          = "${var.iso_url}"

  headless         = "${var.headless}"
  communicator     = "winrm"
  winrm_insecure   = "true"
  winrm_timeout    = "30m"
  winrm_use_ssl    = "true"
  winrm_password   = "${var.ansible_login}"
  winrm_username   = "${var.ansible_password}"

  cpus             = "${var.cpu}"
  disk_compression = "true"
  disk_interface   = "virtio"
  disk_size        = "${var.disk_size}"
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
  machine_type     = "q35" # As of now, q35 is required for secure boot to be enabled
  #vtpm             = true
  efi_boot          = true
  #use_pflash       = true
  efi_firmware_code = "/usr/share/OVMF/x64/OVMF_CODE.4m.fd"
  efi_firmware_vars = "/usr/share/OVMF/x64/OVMF_VARS.4m.fd"
  #efi_firmware_code = "/usr/share/OVMF/x64/OVMF_CODE.secboot.4m.fd"
  #efi_firmware_code = "${path.root}/ovmf/usr/share/OVMF/OVMF_CODE_4M.secboot.fd"
  #efi_firmware_vars = "${path.root}/ovmf/usr/share/OVMF/OVMF_VARS_4M.ms.fd" # efivars with MS keys built-in. This is the closest setup to a real machine as the KEK and PK from MS are generally those setup by OEM manufacturers.

  cd_content     = {
    "Autounattend.xml" = templatefile(
                    "${path.root}/unattend/Autounattend-2025-uefi.xml.pkrtpl", 
                    {
                      tpl_admin_password = "${var.admin_password}",
                      tpl_username = "${var.ansible_login}",
                      tpl_password = "${var.ansible_password}",
                      tpl_keymap = "${var.keymap}",
                      tpl_drive = "E",
                      tpl_timezone = "${var.timezone}"
                    }
                  ),
    "Firstboot-Autounattend.xml" = templatefile(
                    "${path.root}/unattend/Firstboot-Autounattend.xml.pkrtpl", 
                    {
                      tpl_keymap = "${var.keymap}",
                      tpl_timezone = "${var.timezone}"
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
  cd_files     = ["${path.root}/scripts/1-fixnetwork.ps1", "${path.root}/scripts/70-install-misc.bat", "${path.root}/scripts/50-enable-winrm.ps1", "${path.root}/drivers/", "${path.root}/binaries/virtio-win-guest-tools.exe"]
	cd_label         = "install"

  shutdown_command = "${var.shutdown_command}"
  boot_wait        = "3s"
  boot_command = ["<enter>"]
}
