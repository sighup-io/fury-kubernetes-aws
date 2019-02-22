variable "name" {
  type        = "string"
  description = "ElastiCache cluster name"
}

variable "env" {
  type        = "string"
  description = "ElastiCache cluster environment"
}

variable "region" {
  type        = "string"
  default     = "eu-west-1"
  description = "AWS region"
}

variable "redis-nodes-count" {
  type        = "string"
  default     = 1
  description = "ElastiCache cluster nodes number"
}

variable "redis-nodes-type" {
  type        = "string"
  default     = "cache.t2.medium"
  description = "ElastiCache cluster nodes type"
}

variable "redis-password" {
  type = "string"
  description = "ElastiCache Redis password"
}

variable "redis-version" {
  type        = "string"
  default     = "5.0.0"
  description = "ElastiCache Redis engine version"
}

variable "redis-snapshots-retention" {
  type        = "string"
  default     = 7
  description = "ElastiCache Redis snapshosts retention days"
}

variable "subnets" {
  type        = "list"
  description = "List of AWS subnet IDs"
}

provider "aws" {
  region = "${var.region}"
}

data "aws_subnet" "main" {
  count = "${length(var.subnets)}"
  id    = "${element(var.subnets, count.index)}"
}
