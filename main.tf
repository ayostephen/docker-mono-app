locals {
  name = "auto-discovery-mono-app"
}

provider "aws" {
  region  = var.aws_region
  profile = var.profile
}

################################################################
## Creating a VPC using terraform-aws-modules
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs            = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

################################################################
### Security Groups
## Creating security group for docker, nexus, sonarqube, jenkins and backend services

# Creating security group for docker
resource "aws_security_group" "docker-sg" {
  name        = "${local.name}-docker-sg"
  vpc_id      = module.vpc.vpc_id
  description = "security group for docker"

  ingress {
    description = ssh
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_ips
  }

    ingress {
    description = ssh
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = http
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = https
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${local.name}-docker-sg"
    }
}

# Creating security group for nexus
resource "aws_security_group" "nexus-sg" {
    name        = "${local.name}-nexus-sg"
    vpc_id      = module.vpc.vpc_id
    description = "security group for nexus"

    ingress {
        description = ssh
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = var.allowed_ssh_ips
    }

    ingress {
        description = http
        from_port   = 8081
        to_port     = 8081
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = http
        from_port   = 8085
        to_port     = 8085
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = https
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${local.name}-nexus-sg"
    }
}

# Creating security group for sonarqube
resource "aws_security_group" "sonarqube-sg" {
    name        = "${local.name}-sonarqube-sg"
    vpc_id      = module.vpc.vpc_id
    description = "security group for sonarqube"

    ingress {
        description = ssh
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = var.allowed_ssh_ips
    }

    ingress {
        description = http
        from_port   = 9000
        to_port     = 9000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    } 

    ingress {
        description = https
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${local.name}-sonarqube-sg"
    }
}

# Creating security group for jenkins
resource "aws_security_group" "jenkins-sg" {
    name        = "${local.name}-jenkins-sg"
    vpc_id      = module.vpc.vpc_id
    description = "security group for jenkins"

    ingress {
        description = ssh
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = var.allowed_ssh_ips
    }

    ingress {
        description = http
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress = {
        description = http
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = https
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${local.name}-jenkins-sg"
    }
}

## Creating security group for RDS
resource "aws_security_group" "rds-sg" {
    name        = "${local.name}-rds-sg"
    vpc_id      = module.vpc.vpc_id
    description = "security group for RDS"

    dynamic "ingress" {
    for_each = var.allowed_rds_private_cidrs  # Loop over the CIDR list
    content {
      description = "MySQL access"
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${local.name}-rds-sg"
    }
}



################################################################
# Creating an AWS Key Pair using tls
resource "tls_private_key" "auto-dis-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
#kops private key
resource "local_file" "auto-dis-key-pri" {
  content         = tls_private_key.auto-dis-key.private_key_pem
  filename        = "${local.name}-key.pem"
  file_permission = "440"
}
# kops public key
resource "aws_key_pair" "auto-discovery-key-pub" {
  key_name   = "${local.name}-pub-key"
  public_key = tls_private_key.auto-dis-key.public_key_openssh
}
