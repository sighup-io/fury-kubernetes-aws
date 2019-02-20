# resource "aws_elasticache_cluster" "main" {
#   cluster_id               = "${var.name}-${var.env}"
#   engine                   = "redis"
#   node_type                = "${var.node-type}"
#   num_cache_nodes          = 1
#   parameter_group_name     = "${var.name}-${var.env}-redis-cache"
#   engine_version           = "${var.redis-version}"
#   port                     = 6379
#   maintenance_window       = "sun:01:00-sun:05:00"
#   subnet_group_name        = "${aws_elasticache_subnet_group.main.name}"
#   security_group_id        = "${aws_security_group.main.id}"
#   snapshot_window          = "20:00-00:00"
#   snapshot_retention_limit = 30

#   tags {
#     Name        = "${var.name}-${var.env}"
#     Environment = "${var.env}"
#   }
# }

resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.name}-${var.env}"
  subnet_ids = "${var.subnets}"
}

resource "aws_security_group" "main" {
  name_prefix = "${var.name}-${var.env}-elasticache"
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

resource "aws_elasticache_replication_group" "main" {
  replication_group_id          = "${var.name}-${var.env}"
  replication_group_description = "Redis cluster for ${var.name}-${var.env}"
  number_cache_clusters         = "${var.redis-nodes-count}"
  node_type                     = "${var.node-type}"
  automatic_failover_enabled    = "${var.redis-count > 1 ? true : false}"
  auto_minor_version_upgrade    = true
  availability_zones            = "${flatten(data.aws_subnet.main.*.availability_zone)}"
  engine                        = "redis"
  engine_version                = "${var.redis-version}"
  port                          = 6379
  subnet_group_name             = "${aws_elasticache_subnet_group.default.name}"
  security_group_ids            = ["${aws_security_group.main.id}"]
  maintenance_window            = "sun:01:00-sun:05:00"
  snapshot_window               = "21:00-00:00"
  snapshot_retention_limit      = "${var.redis-snapshot-retention}"

  tags {
    Name        = "${var.name}-${var.env}"
    Environment = "${var.env}"
  }
}
