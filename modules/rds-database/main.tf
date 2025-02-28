# Fetch the existing VPC ID (Assuming it's created as a module)
data "aws_vpc" "vpc-id" {
  id = module.vpc.vpc_id
}

# 🔹 RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "multi-az-rds-subnet-group"
  subnet_ids = module.vpc.private_subnets  # Use private subnets for security
  description = "Subnet group for Multi-AZ RDS deployment"

  tags = {
    Name = "Multi-AZ-RDS-Subnet-Group"
  }
}

# 🔹 Multi-AZ RDS Instance
resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20
  engine              = "mysql"  # Change to "postgres", "mariadb", etc. if needed
  engine_version      = "8.0"  # Change version based on requirements
  instance_class      = "db.t3.micro"  # Modify as needed
  db_name            = "mydatabase"
  username          = "admin"
  password          = "MySecurePassword123!"  # Use AWS Secrets Manager instead of hardcoding!
  parameter_group_name = "default.mysql8.0"
  multi_az           = true  # Enables Multi-AZ
  publicly_accessible = false 
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [module.security_groups.rds_sg_id]  # References our SG module
  storage_encrypted     = true
  skip_final_snapshot   = true

  tags = {
    Name = "Multi-AZ-RDS"
    Environment = "dev"
  }
}

