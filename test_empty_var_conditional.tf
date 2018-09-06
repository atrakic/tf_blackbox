# test_empty_var_conditional.tf

variable "empty_var" {
  default = ""
}

resource "null_resource" "test_empty_var_conditional" {
  triggers {
    out = "${length(var.empty_var) == 0 ? 0 : 1}"
  }
}
