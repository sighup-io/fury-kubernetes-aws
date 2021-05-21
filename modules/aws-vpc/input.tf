variable "vpc-cidr" {
  type    = "string"
  default = "10.10.0.0/16"
}

variable "az-count" {
  type        = "string"
  description = "Number of az to deploy the VPC in"
  default     = 3
}

variable "name" {
  type = "string"
}

variable "env" {
  type = "string"
}

variable "region" {
  type    = "string"
  default = "eu-west-1"
}

variable "internal-zone" {
  type        = "string"
  description = "Domain name for internal services"
}

variable "additional-zone" {
  type        = "string"
  default     = ""
  description = "Additional domain name for internal services"
}

data "aws_availability_zones" "available" {}
