variable "token" {}

module "my_do_k8s" {
  source  = "github.com/atrakic/digitalocean-k8s/terraform"
  name    = "test-k8s"
  token   = "${var.token}"
}
