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
  default = "qemu"
}

variable "write_zeros" {
  type    = string
  default = "false"
}

# #################
# TEMPLATE VARS
# #################
variable "arch_add_pkgs" {
  type    = string
  default = ""
}

variable "country" {
  type    = string
  default = "FR"
}

variable "hostname" {
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

variable "template_name" {
  type    = string
  default = "arch"
}

variable "packer_password" {
  type      = string
  default   = "packer"
  sensitive = true
}

# #################
# CLOUD-INIT VARS
# #################

variable "ansible_login" {
  type      = string
  sensitive = true
}

variable "ansible_key" {
  type      = string
  sensitive = true
}

variable "ufw_allow_ssh_ip" {
  type      = string
  sensitive = true
}

variable "ntp_pools" {
  type      = string
  sensitive = false
  default   = "0.arch.pool.ntp.org, 1.arch.pool.ntp.org, 2.arch.pool.ntp.org, 3.arch.pool.ntp.org"
}

variable "locale" {
  type      = string
  sensitive = false
  default   = "en_US"
}
# #################
#  VM VARS
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
#  BUILD VARS
# #################

variable "headless" {
  type    = string
  default = "true"
}
variable "shutdown_command" {
  type    = string
  default = "sudo shutdown now"
}

variable "ssh_timeout" {
  type    = string
  default = "20m"
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
  version          = "${legacy_isotime("2006.01")}"
  iso_base_url     = "https://mirrors.kernel.org/archlinux/iso/${local.version}.01"
  iso_checksum_url = "${local.iso_base_url}/sha1sums.txt"
  iso_url          = "${local.iso_base_url}/archlinux-${local.version}.01-x86_64.iso"
  vm_name          = "${var.template_name}-archlinux-${local.version}"
}

