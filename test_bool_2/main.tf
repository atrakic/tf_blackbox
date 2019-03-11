variable "bool" {
  default = "false"
}

resource "null_resource" "test_bool_2" {
  count = "${var.bool ? 1 : 0}"
  triggers {
   out = "${var.bool}"
  }
}
