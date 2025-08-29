locals {
  vm_name          = "${var.hypervisor}-${var.template_name}-${var.build_type}" 
  out_prefix       = "${local.vm_name}-${var.verion}"
  output_directory = "${local.out_prefix}"
}
