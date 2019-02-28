variable "accounts" {
  type    = "list"
  default = ["1111", "2222", "3333" ]
}

variable "images" {
  type    = "list"
  default = ["alpine", "java", "jenkins"]
}

data "template_file" "generic" {
  count    = "${length(var.accounts) * length(var.images)}"

  template = "${file("../templates/generic.json")}"

  vars {
    #element  = "${element(var.images, count.index)}"
    element   = "${format("%03d", count.index +1)}"

    id    = "${var.accounts[count.index / length(var.images)]}"
    image = "${var.images[count.index % length(var.images)]}"
  }
}

resource "null_resource" "render" {
  count = "${data.template_file.generic.count}"

  triggers {
    ids    = "${var.images[count.index % length(var.images)]}"
    images = "${data.template_file.generic.*.rendered[count.index]}"
  }
}

output "test_json_rendering" {
  description = "Generates a json blocks from the list"
  value       = "${null_resource.render.*.triggers.images}"
}

output "test_element" {
  description = "Subselect element from rendered list"
  value       = "${element(null_resource.render.*.triggers.images, 0)}"
}
