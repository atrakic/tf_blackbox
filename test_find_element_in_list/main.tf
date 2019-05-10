variable "network_mode" {
 description = "Can only be 'none' or 'bridge' or 'host' or 'awsvpc'"
}

locals {
  protocols     = ["none", "bridge", "host", "awsvpc"]
  network_mode = "${element(local.protocols, index(local.protocols, var.network_mode))}"
}

output "network_mode" {
  value = "${local.network_mode}"
}
