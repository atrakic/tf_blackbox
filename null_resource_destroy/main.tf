# https://github.com/hashicorp/terraform/issues/13395
resource "null_resource" "foo" {
  triggers {
    val = "1"
  }

  provisioner "local-exec" {
    command = "echo create provisioner"
  }
  provisioner "local-exec" {
    when = "destroy"
    command = "echo destroy provisioner"
  }

  lifecycle {
    create_before_destroy = true
  }
}
