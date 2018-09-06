# test_list_join.tf

variable "d" {
 type = "list"

 default = [
  "one", 
  "two"
 ]
}

resource "null_resource" "test_list_join" {
  triggers {
   out = "${join (",", var.d)}" 
  }
}

