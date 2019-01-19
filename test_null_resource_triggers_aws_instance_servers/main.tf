variable "instances" {
  default = "webserver:t2.micro,api:t2.small"
}

resource "null_resource" "let" {
  // we reuse this in all counts because count only interpolates from variables
  count = "${length(split(",",var.instances))}"

  triggers {
    // we do the coma splitting here text splitting here
    server_raw = "${element(split(",", var.instances),count.index)}"
  }
}

resource "null_resource" "servers" {
  count = "${length(split(",",var.instances))}"

  triggers {
    // we do the colon splitting here
    name          = "${element(split(":",element(null_resource.let.*.triggers.server_raw, count.index)),0)}"
    instance_type = "${element(split(":",element(null_resource.let.*.triggers.server_raw, count.index)),1)}"
  }
}




/*

Example usage: 
resource "aws_instance" "servers" {

  // number of servers is simply the string split by comma
  count = "${length(split(",",var.instances))}"

  // name is the first bit in each string
  name = "${element(split(":", element(split(",",var.instances),count.index)), 1) }"
  instance_type = "${element(split(":",element(split(",",var.instances),count.index)), 1)}"
}
*/
