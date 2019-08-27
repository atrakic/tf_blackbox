data "terraform_remote_state" "local" {
  backend = "local"

  config {
    path = "terraform.tfstate"
  }

  defaults {
    my_secret = "default_value"
    foo       = "bar"
  }
}

variable "override" {
  default = "pWned"
}

variable "my_secret" {
  default = ""
}

locals {
  content = "${var.my_secret != "" ? var.my_secret : data.terraform_remote_state.local.my_secret}"
}

resource "local_file" "consumer" {
  content  = "${local.content}"
  filename = "/tmp/${local.content}"
}

output "my_secret" {
  value = "${local.content}"
}

output "override" {
  value = "${coalesce(var.override, data.terraform_remote_state.local.foo)}"
}
