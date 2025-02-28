locals {
  name = "auto-discovery-mono-app"
  vpc_id = ""
  public_subnet_id-1 = ""
  public_subnet_id-2 = ""
  public_subnet_id-3 = ""
  private_subnet_id-1 = ""
  private_subnet_id-2 = ""
  private_subnet_id-3 = ""
  jenkins_sg = ""
  bastion_sg = ""
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

data "aws_security_group" "jenkins-sg" {
  id = local.jenkins_sg
}

data "aws_security_group" "bastion-sg" {
  id = local.bastion_sg 
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
  jenkins-master-sg = data.aws_security_group.jenkins-sg.id
}

module "nexus-server" {
  source    = "./modules/nexus-server"
  redhat-ami-id = var.redhat-ami-id
  domain-name = var.domain-name
  instance-type = var.instance-type
  key-name = var.key-name
  subnet-id = data.aws_subnet.public-subnet-1.id
  nexus-sg-id = module.security-groups.nexus-sg-id
}

module "bastion-host" {
  source    = "./modules/bastion-host"
  redhat-ami-id = var.redhat-ami-id
  instance-type = var.instance-type
  key-name = var.key-name
  bastion-sg = var.bastion-sg
  private_key_name = var.private_key_name
  bastion-subnet = data.aws_subnet.public-subnet-2.id
}

module "ansible-server" {
  source    = "./modules/ansible-server"
  redhat-ami-id = var.redhat-ami-id
  instance-type = var.instance-type
  ssh-key-name = var.ssh-key-name
  public_subnet_id = data.aws_subnet.private-subnet-1.id
  ansible_sg = module.security-groups.ansible-sg-id
  stage-playbook = var.stage-playbook
  prod-playbook = var.prod-playbook
  stage-discovery-script = var.stage-discovery-script
  prod-discovery-script = var.prod-discovery-script
  private_key = var.private_key
  nexus-ip = module.nexus-server.public_ip
  nr-key = var.nr-key
  nr-acc-id = var.nr-acc-id
  nr-region = var.nr-region
}

module "rds-database" {
  source    = "./modules/rds-database"
  db-subnet-id = [data.aws_subnet.private-subnet-1.id, data.aws_subnet.private-subnet-2.id, data.aws_subnet.private-subnet-3.id]
  db-name = var.db-name
  db-username = var.db-username
  db-password = var.db-password
  vpc-sg-id = module.security-groups.rds-sg-id
}

module "sonarqube-server" {
  source    = "./modules/sonarqube-server"
  ubuntu-ami-id = var.ubuntu-ami-id
  instance-type = var.instance-type
  key-name = var.key-name
  subnet-id = data.aws_subnet.public-subnet-3.id
  sonarqube-sg = module.security-groups.sonarqube-sg-id
  nr-key = var.nr-key
  nr-acc-id = var.nr-acc-id
  nr-region = var.nr-region
  elb-subnets = var.elb-subnets
  cert-arn = var.cert-arn
  sonar-postgress-pwd = var.sonar-postgress-pwd
  sonar-psqldb-pwd = var.sonar-psqldb-pwd
}