locals {
  name = "auto-discovery-mono-app"
  vpc_id = ""
  public_subnet_id-1 = ""
  public_subnet_id-2 = ""
  public_subnet_id-3 = ""
  private_subnet_id-1 = ""
  private_subnet_id-2 = ""
  private_subnet_id-3 = ""
}

#AWS_VPC 
data "aws_vpc" "vpc" {
  id = local.vpc_id
}

data "aws_subnet" "public-subnet-1" {
  id = local.public_subnet_id-1
}

data "aws_subnet" "public-subnet-2" {
  id = local.public_subnet_id-2
}

data "aws_subnet" "public_subnet-3" {
  id = local.public_subnet_id-3
}

data "aws_subnet" "private-subnet-1" {
  id = local.private_subnet_id-1
}

data "aws_subnet" "private-subnet-2" {
  id = local.private_subnet_id-2
}

data "aws_subnet" "private-subnet-3" {
  id = local.private_subnet_id-3
}

module "security-groups" {
  source          = "./modules/security-groups"
  vpc-id          = data.aws_vpc.vpc.id
  allowed_ssh_ips = var.allowed_ssh_ips
  vpc_cidr        = var.vpc_cidr
  project-name    = var.project-name
  asg-port        = var.asg-port 
  nexus-port-1    = var.nexus-port-1
  nexus-port-2    = var.nexus-port-2
  sonar-port      = var.sonar-port
  rds-port        = var.rds-port
}


module "jenkins-vault-server" {
  source   = "./jenkins-vault_server"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
}

module "nexus-server" {
  source    = "./modules/nexus-server"
  subnet_id = module.vault-server.public_subnet_ids[0]
  vpc_id    = module.vault-server.vpc_id
}

module "bastion-host" {
  source    = "./modules/bastion-host"
  subnet_id = module.vault-server.public_subnet_ids[0]  # Bastion should be in public subnet
  vpc_id    = module.vault-server.vpc_id
}

