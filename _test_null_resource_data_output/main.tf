variable "matrix" {
  type = "map"
  default = {
    chars   = "a,b,c"
    numbers = "1,2,3"
    tld     = "com,net,org"
  }
}

data "null_data_source" "values" {
  count = "${length(split(",",var.matrix["chars"]))}"
  inputs = {
    //foo = "foo"
    //bar = "bar"
    chars        = "${element(split(",", var.matrix["chars"]), count.index)}"
    tld          = "${element(split(",", var.matrix["tld"]), count.index)}"
    numbers      = "${element(split(",", var.matrix["numbers"]), count.index)}"
  }
}

output "test_0" {
  value = "${data.null_data_source.values.*.outputs[0]}"
}

output "test_1" {
  value = "${data.null_data_source.values.*.outputs[1]}"
}

output "test_2" {
  value = "${data.null_data_source.values.*.outputs[2]}"
}
