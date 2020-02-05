variable "instance-count" {
  type = "string"
  default = "1"
  description = "How many instances to create"
}

variable "zone-id" {
  type = "string"
  description = "Zone id to use to instantiate internal dns"
}

variable "name" {
  type        = "string"
  description = "Instance name"
}

variable "env" {
  type        = "string"
  description = "Instance environment"
}

variable "root-volume-size" {
  type = "string"
  description = "Instances root volume size"
  default = "50"
}

variable "ami-owner" {
  type = "string"
  default = "099720109477"
  description = "AMI Owner"
}

variable "ami-filter" {
  type        = "string"
  default     = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  description = "Default AMI"
}

data "aws_ami" "ec2" {
  most_recent = true
  owners = ["${var.ami-owner}"]

  filter {
    name   = "name"
    values = ["${var.ami-filter}"]
  }
}

variable "instance-type" {
  type = "string"
  description = "AWS ec2 instance type, eg: t3.medium"
}

variable subnets {
  type        = "list"
  description = "List of AWS private subnet IDs"
}

variable "security-group-id" {
  type = "string"
  description = "security group to attach on instances"
}