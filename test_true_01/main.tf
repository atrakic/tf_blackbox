variable "foo" { default = false }

locals {
  foo = "foo"
  bar = "bar"
}

output "test_true" {
  value = "${var.foo ? local.foo : local.bar}"
}
