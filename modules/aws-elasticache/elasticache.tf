resource "aws_elasticache_cluster" "main" {
  cluster_id               = "${var.name}-${var.env}"
  engine                   = "redis"
  node_type                = "${var.node-type}"
  num_cache_nodes          = 1
  parameter_group_name     = "${var.name}-${var.env}-redis-cache"
  engine_version           = "${var.redis-version}"
  port                     = 6379
  maintenance_window       = "sun:01:00-sun:05:00"
  subnet_group_name        = "${aws_elasticache_subnet_group.main.name}"
  security_group_id        = "${aws_security_group.main.id}"
  snapshot_window          = "20:00-00:00"
  snapshot_retention_limit = 30

  tags {
    Name        = "${var.name}-${var.env}"
    Environment = "${var.env}"
  }
}

resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.name}-${var.env}"
  subnet_ids = "${var.subnets}"
}

resource "aws_security_group" "main" {
  name_prefix = "${var.name}-${var.env}"
  vpc_id      = "${aws_subnet.main.0.vpc_id}"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_elasticache_replication_group" "main" {
#   replication_group_id          = "${var.name}-${var.env}"
#   replication_group_description = "Redis cluster for ${var.name}-${var.env}"


#   engine = "redis"
#   engine_version = "${var.redis-version}"
#   node_type            = "${var.node-type}"
#   port                 = 6379
#   parameter_group_name = "${var.name}.${var.env}"


#   snapshot_retention_limit = 5
#   snapshot_window          = "00:00-05:00"


#   subnet_group_name          = "${aws_elasticache_subnet_group.default.name}"
#   automatic_failover_enabled = true


#   cluster_mode {
#     replicas_per_node_group = 1
#     num_node_groups         = "${var.node_groups}"
#   }
# }

