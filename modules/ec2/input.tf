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

variable ssh-public-keys {
  type        = "list"
  description = "List of public SSH keys authorized to connect to instances"
}

variable "assign-eip-address" {
  description = "Assign an Elastic IP address to the instance"
  default     = "true"
}

variable "associate-public-ip-address" {
  description = "Associate a public IP address with the instance"
  default     = "true"
}


variable ssh-private-key {
  type        = "string"
  description = "Path to own private key to access machines"
}


variable user {
  type        = "string"
  description = "default user on ec2"
  default = "ubuntu"
}

variable "ansible-name" {
  type = "string"
  default = "instance"
  description = "Name on group and instances on generated hosts ini"
}