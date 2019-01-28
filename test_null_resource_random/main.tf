provider "null" {}

data "null_data_source" "value" {}

resource "null_resource" "random" {
  triggers {
    "random" = "${data.null_data_source.value.random}"
  }
}

output "random" {
  value = "${null_resource.random.triggers.random}"
}
