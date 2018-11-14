# test_matrix.tf

variable "matrix" {
  type = "map"
  default = {
    chars   = "a,b,c"
    numbers = "1,2,3"
    tld     = "com,net,org"
  }
}

resource "null_resource" "test_matrix" {
  count = "${length(split(",",var.matrix["chars"]))}"

  triggers {
    chars        = "${element(split(",", var.matrix["chars"]), count.index)}"
    numbers      = "${element(split(",", var.matrix["numbers"]), count.index)}"
    tld          = "${element(split(",", var.matrix["tld"]), count.index)}"
  }
}
