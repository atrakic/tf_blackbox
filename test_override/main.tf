variable "default" { default = "" }

data "null_data_source" "value" {}

output "test_override" {
  value = "${length(var.default) > 0 ? var.default : data.null_data_source.value.random}"
}
