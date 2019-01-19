locals {
  date = "${data.external.program.result}"
}

data "external" "program" {
  program = ["sh", "-c", "echo \"{\\\"date\\\" : \\\"$(date +%s)\\\"}\""]
}

output "result" {
  value = "${local.date}"
}

// extended: 

variable "commands" {
  description = "Extended list of commands"
  type = "map"

  default = {
    pwd = "$(pwd)"
    echo = "$(echo 'foo')"

#  these dont produce single lined output, hence wrong JSON 
#    ls   = "$(ls)"
#    w    = "$(w)"
#    ping = "$(ping -c 1 127.0.0.1)"
  }
}

data "external" "more_programs" {
  #count = "$(length(keys(var.commands))}" 
  #count = "${length(split(",", var.commands))}"
  count   = "2"
  program = ["sh", "-c", "echo \"{\\\"{element(keys(var.commands), count.index)}\\\" : \\\"${element(values(var.commands), count.index)}\\\"}\""]
}
