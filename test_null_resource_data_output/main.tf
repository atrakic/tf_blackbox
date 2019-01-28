variable "matrix" {
  type = "map"
  default = {
    char   = "a,b,c"
    number = "1,2,3"
    tld     = "com,net,org"
  }
}

data "null_data_source" "values" {
  count = "${length(split(",",var.matrix["char"]))}"
  inputs = {
    chars       = "${element(split(",", var.matrix["char"]), count.index)}"
    numbers     = "${element(split(",", var.matrix["number"]), count.index)}"
    tlds        = "${element(split(",", var.matrix["tld"]), count.index)}"
  }
}

output "chars" {
  value = "${data.null_data_source.values.*.outputs.chars}"
}

output "numbers" {
  value = "${data.null_data_source.values.*.outputs.numbers}"
}

output "tlds" {
  value = "${data.null_data_source.values.*.outputs.tlds}"
}

