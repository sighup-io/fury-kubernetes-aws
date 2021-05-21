output "vpc" {
  value = "${aws_vpc.main.id}"
}

output "public_subnets" {
  value = "${flatten(aws_subnet.public.*.id)}"
}

output "private_subnets" {
  value = "${flatten(aws_subnet.private.*.id)}"
}

output "domain_zone" {
  value = "${aws_route53_zone.main.id}"
}

output "additional_zone" {
  value = "${aws_route53_zone.additional.*.id}"
}

output "main_internet_gateway" {
  value = "${aws_internet_gateway.main.id}"
}
