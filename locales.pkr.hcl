locals {
  vm_name          = "${var.template_name}-${var.build_type}" 
  out_prefix       = "${local.vm_name}-${var.archiso_verion}"
  output_directory = "${local.out_prefix}"
  iso_checksum_url = "../archiso/test/${var.archiso_verion}.iso.sum"
  iso_url          = "../archiso/test/${var.archiso_verion}.iso"
}
