// https://github.com/hashicorp/terraform/pull/12757#issuecomment-294030969

resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo hi >${path.module}/hi.txt"
  }
}

data "local_file" "example" {
  // Ensure this is evaluated only *after* the above provisioner runs
  depends_on = ["null_resource.example"]

  filename = "${path.module}/hi.txt"
}

output "result" {
  value = "${data.local_file.example.content}"
}
