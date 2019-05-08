variable "list" {
  default = ["foo", "bar"]
}

locals {
  foo = "${length(var.list) > 0 ? length(var.list) : 0}"
}

resource "null_resource" "test_element" {
  count = "${local.foo}"

  triggers {
    out = "${element(var.element, count.index)}"
  }
}

output "test_element" {
  value = "${null_resource.test_element.*.triggers}"
}
