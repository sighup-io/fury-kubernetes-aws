locals {
  inventory = <<EOF
[${var.ansible-name}]
${join("\n", formatlist("%s ansible_host=%s", data.template_file.instance.*.rendered, aws_instance.ec2.*.private_ip))}

[all:vars]
ansible_user=${var.user}
ansible_ssh_private_key_file='${var.ssh-private-key}'
ansible_python_interpreter=python3

EOF
}

output "inventory" {
  value = "${local.inventory}"
}


data "template_file" "instance" {
  count = "${var.instance-count}"

  template = "${var.ansible-name}-$${index}"

  vars {
    index = "${count.index}"
  }
}