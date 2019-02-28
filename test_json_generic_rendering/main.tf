variable "accounts" {
  type    = "list"
  default = ["1111", "2222"]
}

variable "images" {
  type    = "list"
  default = ["alpine", "java", "jenkins"]
}

data "template_file" "generic" {
  count = "${length(var.accounts) * length(var.images)}"

  template = "${file("../templates/generic.json")}"

  vars {
    element1 = "foo${count.index}"
    element2 = "bar${count.index}"

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
  value = "${null_resource.render.*.triggers.images}"
}

#output "test_ids" {
#  value = "${null_resource.render.*.triggers.ids}"
#}

