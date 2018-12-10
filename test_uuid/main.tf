resource "null_resource" "test_uuid" {
  triggers {
   out = "${uuid()}"
  }
}
