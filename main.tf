variable "bool1" {
  default = "true"
}

variable "bool2" {
  default = "false"
}

variable "a" {
  type = "map"

  default = {
    "k1" = "v1"
    "k2" = "v2"
    "k3" = "v3"
  }
}

variable "b" {
  type = "map"

  default = {
    "k7" = "v7"
    "k6" = "v6"
    "k5" = "v5"
  }
}

variable "c" {
  type = "map"

  default = {
    "k8" = "v8"
    "k9" = "v9"
  }
}

variable "d" {
 type = "list"

 default = [
  "one", 
  "two"
 ]
}


// 

resource "random_string" "default" {
  length = 16
}


// main()

resource "null_resource" "test_1" {
  triggers {
   out = "${var.bool1}"
  }
}

resource "null_resource" "test_2" {
  triggers {
  out = "${contains(var.d,"test")}"
  }
}

resource "null_resource" "test_3" {
  triggers {
  out = "${join(",",keys(var.a), values(var.a))}"
  }
}

resource "null_resource" "test_4" {
  triggers {
   out = "${join (",", var.d)}" 
  }
}

resource "null_resource" "test_5" {
  triggers {
    random_default   = "${random_string.default.result}"
  }
}
