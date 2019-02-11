variable "my_list" {
  type = "list"
  description = "The name of each DB account to associate with IAM auth"
  default = [ "one", "two" ]
}

resource "null_resource" "let" {
  count = "${length(var.my_list)}"

  triggers {
    foo = "${var.my_list[count.index]}"
  }
}

output "test_formatlist" {
  value = "${formatlist("arn:aws:rds-db:%s:%s:dbuser:%s/%s",
                   "aa",
                    "bb",
                    "cc",
                    "${null_resource.let.*.triggers.foo}"
                    )}"
}
