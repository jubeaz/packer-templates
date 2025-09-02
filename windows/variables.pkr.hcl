variable "hypervisor" {
  type = string
}
variable "build_type" {
  type    = string
}
variable "template_name" {
  type    = string
}

variable "verion" {
  type = string
}

variable "packer_user" {
  type      = string
  default   = "packer"
}

variable "admin_password" {
  type      = string
  default   = "Zaebuj12345+-"
}


variable "ansible_login" {
  type      = string
}

variable "ansible_password" {
  type      = string
}

variable "packer_password" {
  type      = string
  default   = "packer"
}

variable "hostname" {
  type    = string
  default = "Windows"
}
variable "keymap" {
  type    = string
  default = "fr-FR"
}

variable "accelerator" {
  type    = string
  default = "kvm"
}

variable "autounattend" {
  type    = string
}

variable "cpu" {
  type    = string
  default = "4"
}

variable "disk_size" {
  type    = string
  default = "61440"
}

variable "headless" {
  type    = string
  default = "false"
}

variable "iso_checksum" {
  type    = string
}

variable "iso_url" {
  type    = string
}

variable "ram" {
  type    = string
  default = "4096"
}

variable "shutdown_command" {
  type    = string
  default = "%WINDIR%/system32/sysprep/sysprep.exe /generalize /oobe /shutdown /unattend:C:/Windows/Temp/Autounattend.xml"
}

variable "vm_name" {
  type    = string
}