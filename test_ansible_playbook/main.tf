provider "null" {
  version = "~> 1.0"
}

variable "text" {
  default = "Hello Ansible from TF!"
}

variable "myfile" {
  default = "/tmp/ansbile_file.txt"
}

variable "playbook" {
  default = "playbook.yml"
}

resource "null_resource" "test_ansible" {
  triggers = {
    out = "${uuid()}"
  }

  provisioner "local-exec" {
    command = <<EOF
ANSIBLE_LOCALHOST_WARNING=0 ANSIBLE_NOCOLOR=true PYTHONUNBUFFERED=1 \
/usr/bin/ansible-playbook -c ansible_connection=local \
    ansible/${var.playbook} -e 'msg="${var.text}" myfile="${var.myfile}"'
EOF
  }
}
