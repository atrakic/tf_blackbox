variable "my_list" {
  type = "list"
  description = "The name of each DB account to associate with IAM auth"
  default = [ "one", "two" ]
}

output "test_formatlist_02" {
  value = "${formatlist("arn:aws:rds-db:%s:%s:dbuser:%s/%s",
                   "aa",
                    "bb",
                    "cc",
                    "${split(",", join(",", var.my_list))}"
                    )}"
}
