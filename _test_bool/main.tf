variable "bool1" {
  default = "true"
}

resource "null_resource" "test_bool_1" {
  triggers {
   out = "${var.bool1}"
  }
}
