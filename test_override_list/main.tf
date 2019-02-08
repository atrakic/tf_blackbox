variable "default_order" { default = ["first", "second"] }

locals {
  override_list = ["1","2", "3" ]
  final_list   = ["${distinct(compact(coalescelist(local.override_list, var.default_order)))}"]
}

output "test_list_override" {
  value = "${local.final_list}"
}
