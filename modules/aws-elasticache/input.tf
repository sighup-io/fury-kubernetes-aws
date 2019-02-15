variable "name" {
  type        = "string"
  description = "ElastiCache cluster name"
}

variable "env" {
  type        = "string"
  description = "ElastiCache cluster environment"
}

variable "node-type" {
  type        = "string"
  default     = "cache.t2.medium"
  description = "ElastiCache cluster node type"
}

variable "redis-version" {
  type        = "string"
  default     = "5.0.0"
  description = "ElastiCache Redis engine version"
}

variable "subnets" {
  type        = "list"
  description = "List of AWS subnet IDs"
}

data "aws_subnet" "main" {
  count = "${length(var.subnets)}"
  id    = "${element(var.subnets, count.index)}"
}
