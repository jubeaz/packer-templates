locals {
  version          = "archlinux-2025.05.18-x86_64"
  iso_checksum_url = "../archiso/test/${local.version}.iso.sum"
  iso_url          = "../archiso/test/${local.version}.iso"
  out_prefix       = "${var.template_name}-${var.build_type}-${local.version}"
}
