variable "a" {
  type = "map"
  default = {
    "k1" = "v1"
    "k2" = "v2"
    "k3" = "v3"
  }
}

resource "null_resource" "test_join_key_vals" {
  triggers {
  out = "${join(",",keys(var.a), values(var.a))}"
  }
}

