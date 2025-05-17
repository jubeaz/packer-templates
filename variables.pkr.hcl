# https://www.packer.io/docs/templates/hcl_templates/variables#type-constraints for more info.
# #################
# DISK INFO
# #################
#variable "is_uefi" {
#  type    = string
#  default = "false"
#}

variable "build_type" {
  type    = string
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

variable "countries" {
  type    = string
  default = "France"
}

variable "hostname" {
  type    = string
  default = "Archlinux"
}

variable "domain" {
  type    = string
  default = "local"
}

variable "keymap" {
  type    = string
  default = "fr"
}

variable "locale" {
  type    = string
  default = "fr_FR.UTF-8"
}

variable "template_name" {
  type    = string
  default = "arch"
}

variable "packer_user" {
  type      = string
  default   = "packer"
  sensitive = false
}

variable "packer_password" {
  type      = string
  default   = "packer"
  sensitive = false
}

# #################
# CLOUD-INIT VARS
# #################

variable "ansible_login" {
  type      = string
  sensitive = true
}

variable "ansible_password" {
  type      = string
  sensitive = true
}

#variable "ansible_key" {
#  type      = string
#  sensitive = true
#}

variable "ufw_allow_ssh_ip" {
  type      = string
  sensitive = true
}

variable "ntp_pools" {
  type      = string
  sensitive = false
  default   = "0.arch.pool.ntp.org, 1.arch.pool.ntp.org, 2.arch.pool.ntp.org, 3.arch.pool.ntp.org"
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
