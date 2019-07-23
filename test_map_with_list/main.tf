variable "foo" {
  type = "map"
  default = {
    a = [ "one", "two","three" ]
    b = [ "four","five","six" ]
}
}

output "res" {
  value = "${var.foo["a"]}"
}

