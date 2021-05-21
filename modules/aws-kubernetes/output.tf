locals {
  inventory = <<EOF
[master]
${join("\n", formatlist("%s ansible_host=%s", data.template_file.k8s-master.*.rendered, aws_instance.k8s-master.*.private_ip))}

[gated:children]
master
${join("\n", data.template_file.k8s-worker-kind.*.rendered)}

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file='${var.ssh-private-key}'
ansible_python_interpreter=python3

[bastion:vars]
dns_server=${cidrhost(data.aws_vpc.main.cidr_block, 2)}

[gated:vars]
public_lb_address=${aws_lb.external.dns_name}

[master:vars]
etcd_initial_cluster='${join(",", formatlist("%s=https://%s:2380", data.template_file.k8s-master.*.rendered, aws_route53_record.k8s-master.*.fqdn))}'
control_plane_endpoint=${aws_route53_record.control-plane.fqdn}
dns_zone=${join(".", compact(split(".", data.aws_route53_zone.main.name)))}

EOF
}

output "inventory" {
  value = "${local.inventory}"
}

output "external-lb-arn" {
  value = "${aws_lb.external.arn}"
}


data "template_file" "k8s-master" {
  count = "${var.kube-master-count}"

  template = "master-$${index+1}"

  vars {
    index = "${count.index}"
  }
}

data "template_file" "k8s-worker-kind" {
  count    = "${length(var.kube-workers)}"
  template = "$${kind}"

  vars {
    kind = "${lookup(var.kube-workers[count.index], "kind")}"
  }
}

#data "template_file" "k8s-worker-node" {
#  count = "${data.aws_instances.main.count}"
#
#  template = <<EOF
#[$${kind}]
#$${nodes}
#EOF
#
#  vars {
#    kind  = "${lookup(var.kube-workers[count.index], "kind")}"
#    nodes = "${join("\n", data.aws_instances.main.*.private_ips[count.index])}"
#  }
#}


output "internal-lb-http-dns-name" {
  value = "${aws_lb.internal-http.dns_name}"
}
