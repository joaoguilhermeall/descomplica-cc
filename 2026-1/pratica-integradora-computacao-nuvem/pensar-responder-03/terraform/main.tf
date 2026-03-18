# Configuração do Terraform e Provider AWS
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Gera senha aleatória para o banco de dados
resource "random_password" "db_password" {
  length  = 16
  special = false
}

# Security Group para permitir acesso MySQL
resource "aws_security_group" "mysql_sg" {
  name        = "english-learning-mysql-sg"
  description = "Allow MySQL inbound traffic for English Learning DB"

  ingress {
    description = "MySQL from anywhere (educational purposes only)"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "english-learning-mysql-sg"
    Environment = "development"
    Project     = "english-learning"
  }
}

# Instância RDS MySQL
resource "aws_db_instance" "english_learning_db" {
  identifier           = "english-learning-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0.35"
  instance_class       = "db.t3.micro"
  db_name              = "english_learning"
  username             = "admin"
  password             = random_password.db_password.result
  parameter_group_name = "default.mysql8.0"

  # Configurações de acesso público (apenas para fins educacionais)
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]

  # Configurações de backup e manutenção
  backup_retention_period = 0
  skip_final_snapshot     = true

  tags = {
    Name        = "english-learning-db"
    Environment = "development"
    Project     = "english-learning"
  }
}

# Outputs para facilitar acesso ao banco de dados
output "db_endpoint" {
  description = "Endpoint de conexão do banco de dados"
  value       = aws_db_instance.english_learning_db.endpoint
}

output "db_endpoint_address" {
  description = "Endereço do endpoint (sem porta)"
  value       = aws_db_instance.english_learning_db.address
}

output "db_name" {
  description = "Nome do banco de dados"
  value       = aws_db_instance.english_learning_db.db_name
}

output "db_username" {
  description = "Usuário administrador do banco"
  value       = aws_db_instance.english_learning_db.username
}

output "db_password" {
  description = "Senha do banco de dados (sensível)"
  value       = random_password.db_password.result
  sensitive   = true
}

output "connection_command" {
  description = "Comando para conectar ao banco de dados"
  value       = "mysql -h ${aws_db_instance.english_learning_db.address} -u ${aws_db_instance.english_learning_db.username} -p"
}
