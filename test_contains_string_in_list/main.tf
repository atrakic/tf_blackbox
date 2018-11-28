# test_contains_string_in_list.tf

variable "c" {
 type = "list"

 default = [
  "one", 
  "two"
 ]
}

resource "null_resource" "test_contains_string_in_list" {
  triggers {
  out = "${contains(var.c,"test")}"
  }
}

