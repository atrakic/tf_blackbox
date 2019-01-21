variable "matrix" {
  type = "map"
  default = {
    chars   = "a,"
    numbers = "1,"
    tld     = "com,"
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


/*
data "null_data_source" "values" {
  # FIXME: https://www.terraform.io/docs/providers/null/data_source.html
  count = "${length(split(",",var.matrix["chars"]))}"
  inputs = {
    all_chars = "${null_resource.test_matrix.*.id}"
  }
}
locals {
  # FIXME:
  ssm_dbs     = "${data.null_resource.test_matrix[0]"
  ssm_users   = "${data.aws_ssm_parameter.dbuser.value}"
  ssm_passwds = "${data.aws_ssm_parameter.dbpass.value}"
}

output "chars" {
  # FIXME: https://www.terraform.io/docs/providers/null/data_source.html
  //value       = "${data.null_data_source.values.outputs["all_chars"]}"
  value       = "${data.null_data_source.values.*.outputs}" 
}

test: 
  terraform state show "null_resource.test_matrix[0]"

*/
