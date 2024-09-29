data "aws_vpc" "selected" {
  id = "vpc-0a644377c29b94739"
}

data "aws_subnet" "subnet1" {
  id = "subnet-0115eee2625c3d9a0"
}

data "aws_subnet" "subnet2" {
  id = "subnet-003d6328b6b8d9084"
}

data "aws_secretsmanager_secret" "redis_host" {
  name = "my-redis-replication-group-001.axvta7.0001.sae1.cache.amazonaws.com"
}

data "aws_secretsmanager_secret" "redis_port" {
  name = "6379"
}

data "aws_secretsmanager_secret" "redis_password" {
  name = ""
}