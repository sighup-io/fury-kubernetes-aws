resource "aws_instance" "ec2" {
  count                  = "${var.instance-count}"
  ami                    = "${data.aws_ami.ec2.id}"
  instance_type          = "${var.instance-type}"
  subnet_id              = "${element(var.subnets, count.index)}"
  associate_public_ip_address = "${var.associate-public-ip-address}"
  vpc_security_group_ids = ["${var.security-group-id}"]
  user_data              = "${data.template_cloudinit_config.config.rendered}"

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "${var.root-volume-size}"
    delete_on_termination = "true"
  }

  tags {
    Name              = "instance-${var.name}-${var.env}-${count.index + 1}"
  }
}

resource "aws_route53_record" "k8s-master" {
  count   = "${var.instance-count}"
  zone_id = "${var.zone-id}"
  name    = "${var.name}-${count.index + 1}"
  type    = "A"
  ttl     = "600"

  records = [
    "${element(aws_instance.ec2.*.private_ip, count.index)}",
  ]
}


resource "aws_eip" "eip" {
  count             = "${var.associate-public-ip-address == "true" && var.assign-eip-address == "true"}"
  network_interface = "${aws_instance.ec2.primary_network_interface_id}"
  vpc               = "true"
}
