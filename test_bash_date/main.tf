locals {
    date = "${data.external.bash_command.result}"
}

data "external" "bash_command" {
    program = ["bash", "-c", "echo \"{\\\"date\\\" : \\\"$(date +%s)\\\"}\""]
}

output "bash_date" {
    value = "${local.date}"
}
