variable "matrix" {
  type = "map"

  default = {
    chars   = "a,b,c"
    numbers = "1,2,3"
    tld     = "com,net,org"
  }

  description = "Matrix is a rectangular array of numbers, symbols, or expressions, arranged in rows and columns."
}

resource "null_resource" "test_matrix" {
  count = "${length(split(",",var.matrix["chars"]))}"

  triggers {
    chars   = "${element(split(",", var.matrix["chars"]), count.index)}"
    numbers = "${element(split(",", var.matrix["numbers"]), count.index)}"
    tlds    = "${element(split(",", var.matrix["tld"]), count.index)}"
  }
}

output "chars" {
  value = "${null_resource.test_matrix.*.triggers.chars}"
}

output "numbers" {
  value = "${null_resource.test_matrix.*.triggers.numbers}"
}

output "tlds" {
  value = "${null_resource.test_matrix.*.triggers.tlds}"
}
