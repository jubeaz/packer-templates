# https://www.packer.io/docs/templates/hcl_templates/variables#type-constraints for more info.
# #################
# DISK INFO
# #################
variable "is_uefi" {
  type    = string
  default = "false"
}

variable "packer_build_type" {
  type    = string
}

variable "write_zeros" {
  type    = string
  default = "true"
}

# #################
#
# #################
variable "arch_add_pkgs" {
  type    = string
}

variable "country" {
  type    = string
  default = "FR"
}

variable "fqdn" {
  type    = string
  default = "Archlinux"
}

variable "keymap" {
  type    = string
  default = "fr-latin1"
}

variable "language" {
  type    = string
  default = "en_US.UTF-8"
}
variable "distro" {
  type    = string
  default = "arch"
}


# #################
# USER INFO
# #################
variable "with_vagrant" {
  type    = string
  default = "False"
}

variable "packer_password" {
  type      = string
  default   = "packer"
  sensitive = true
}

variable "root_password" {
  type      = string
  sensitive = true
}

variable "ansible_login" {
  type      = string
  sensitive = true
}

variable "ansible_password" {
  type      = string
  sensitive = true
}


# #################
#  VM DATA
# #################

variable "cpu" {
  type    = string
  default = "2"
}

variable "ram" {
  type    = string
  default = "2048"
}

variable "disk_size" {
  type    = string
  default = "20480"
}

# #################
#  VM DATA
# #################

variable "headless" {
  type    = string
  default = "true"
}
variable "shutdown_command" {
  type    = string
  default = "sudo systemctl start poweroff.timer"
}

variable "ssh_timeout" {
  type    = string
  default = "20m"
}

variable "name" {
  type    = string
  default = "archlinux"
}


variable "qemu_out_dir" {
  type    = string
}
# The "legacy_isotime" function has been provided for backwards compatability, but we recommend switching to the timestamp and formatdate functions.

# All locals variables are generated from variables that uses expressions
# that are not allowed in HCL2 variables.
# Read the documentation for locals blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/locals
locals {
  _packer_password = "${uuidv4()}"
  iso_base_url     = "https://mirrors.kernel.org/archlinux/iso/${local.version}.01"
  iso_checksum_url = "${local.iso_base_url}/sha1sums.txt"
  iso_url          = "${local.iso_base_url}/archlinux-${local.version}.01-x86_64.iso"
  version          = "${legacy_isotime("2006.01")}"
  vm_name          = "${var.distro}-${local.version}"
}

