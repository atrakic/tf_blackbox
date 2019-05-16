variable "stuff_enabled" {
 type    = "list"
 default = ["foo", "bar"]
}

variable "enabled" { description = "Enabled 'true' or 'false'?"}
variable "input"   { description = "I have foo and bar, your lookup? " }

locals {
  enabled     = "${var.enabled == "true" ? true : false}"
  input_result = "${local.enabled && contains(var.stuff_enabled, var.input) == true}"
}

resource "null_resource" "let" {
  count = "${local.input_result == "true" ? 1 : 0}"

  triggers{
    enabled = "${var.input}"
  }
}

output "enabled" {
  value = "${null_resource.let.*.triggers.enabled}"
}



module "skeleton" {
  source = "git::https://github.com/8cloud8/terraform-modules.git//providers/aws/skeleton?ref=master"
  enabled = "${local.input_result}"
}

output "account_id" {
  value = "${module.skeleton.account_id}"
}

output "user_id" {
  value = "${module.skeleton.user_id}"
}

output "region" {
  value = "${module.skeleton.region}"
}

output "arn" {
  value = "${module.skeleton.arn}"
}
