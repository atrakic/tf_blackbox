terraform {
  required_version = ">= 0.11.13"
}

variable "use_random" {}

locals {
 random = "${var.use_random == "true" ? 1 : 0}"

 foo = "${local.random ? coalesce("", random_pet.master_username.id) : "default"}"
 bar = "${local.random ? coalesce("", random_id.master_password.b64) : "default"}" 
}

resource "random_pet" "master_username" {
  # https://github.com/hashicorp/terraform/issues/21243
  #count = "${local.random}"
}

resource "random_id" "master_password" {
  # https://github.com/hashicorp/terraform/issues/21243
  #count = "${local.random}"
  byte_length = 10
}

output "test_random" {
 value = <<-MSG

 foo=${local.foo} 
 bar=${local.bar}
 MSG
}
