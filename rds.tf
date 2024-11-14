variable "aws-region" {
  type        = string
  description = "Região da AWS"
  default     = "sa-east-1"
}

terraform {

  backend "s3" {
    bucket  = "6soat-tfstate"
    key     = "terraform-rds/terraform.tfstate"
    region  = "sa-east-1"
    encrypt = true
  }

  required_providers {

    random = {
      version = "~> 3.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.65"
    }
  }
}

provider "aws" {
  region = "sa-east-1"
}

resource "aws_db_subnet_group" "dbgroupsubnet" {
  name       = "techchallenge-subnet-group"
  subnet_ids = [data.aws_subnet.subnet1.id, data.aws_subnet.subnet2.id]

  tags = {
    Name = "My DB Subnet Group"
  }
}

resource "random_string" "username" {
  length  = 14
  special = false
  upper   = true
}

resource "random_string" "password" {
  length           = 16
  special          = false
  override_special = "/@\" "
}

output "secrets_policy" {
  value = aws_iam_policy.secretsPolicy.arn
}

output "secrets_id" {
  value = aws_secretsmanager_secret.db_credentials.id
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "dbcredentialsv2"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username       = random_string.username.result
    password       = random_string.password.result
    host           = aws_db_instance.postgresdb.address
    port           = aws_db_instance.postgresdb.port
    db             = aws_db_instance.postgresdb.db_name
    redis_host     = "my-redis-replication-group-001.p6lc45.0001.sae1.cache.amazonaws.com"
    redis_port     = "6379"
    redis_password = ""
    typeorm        = "postgres://${random_string.username.result}:${random_string.password.result}@${aws_db_instance.postgresdb.address}:${aws_db_instance.postgresdb.port}/${aws_db_instance.postgresdb.db_name}"
  })
}

resource "aws_iam_policy" "secretsPolicy" {
  name = "podsecrets-deployment-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
        Resource = [aws_secretsmanager_secret.db_credentials.arn]
      },
    ]
  })
}

resource "aws_db_instance" "postgresdb" {
  allocated_storage       = 10
  identifier              = "avalanchespostgres"
  db_name                 = "avalanches_database"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.micro"
  username                = random_string.username.result
  password                = random_string.password.result
  skip_final_snapshot     = true
  publicly_accessible     = true
  storage_encrypted       = true
  backup_retention_period = 30
}
