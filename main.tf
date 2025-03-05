locals {
  name                = "auto-discovery-mono-app"
  jenkins-sg-id = "sg-0e6636f5d66483535"
  private_subnet_id-1 = "subnet-0318b572cc17a51ec"
  private_subnet_id-2 = "subnet-01b511fda853de029"
  private_subnet_id-3 = "subnet-0e828da1d12fb6493"
  public_subnet_id-1 = "subnet-04b262777d7de1586"
  public_subnet_id-2 = "subnet-0e2c944c40b75ebdf"
  public_subnet_id-3 = "subnet-064e3eea6bee4d804"
  vpc_id = "vpc-081c48d656eafbe6b"
  # vpc_id              = ""
  # public_subnet_id-1  = ""
  # public_subnet_id-2  = ""
  # public_subnet_id-3  = ""
  # private_subnet_id-1 = ""
  # private_subnet_id-2 = ""
  # private_subnet_id-3 = ""
  # jenkins_sg          = ""
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
  id = local.jenkins-sg-id
}

# data "aws_security_group" "bastion-sg" {
#   id = local.bastion_sg
# }

module "security-groups" {
  source            = "./modules/security-groups"
  vpc-id            = data.aws_vpc.vpc.id
  allowed_ssh_ips   = var.allowed_ssh_ips
  project-name      = var.project-name
  asg-port          = var.asg-port
  nexus-port-1      = var.nexus-port-1
  nexus-port-2      = var.nexus-port-2
  sonar-port        = var.sonar-port
  rds-port          = var.rds-port
  jenkins-master-sg = data.aws_security_group.jenkins-sg.id
}

module "keypair" {
  source = "./modules/keypair"
}

module "jenkins-slaves" {
  source        = "./modules/jenkins_servers"
  ami_id = var.ami_id
  # ami_ubuntu = var.ami_ubuntu
  # domain-name   = var.domain-name
  instance_type = var.instance_type
  key_name      = module.keypair.infra-pub-key
  subnet_id     = data.aws_subnet.public-subnet-1.id
  jenkins_sg = data.aws_security_group.jenkins-sg
  # nexus-ip = var.nexus-ip
  nr-region = var.nr-region
  nr-acc-id = var.nr-acc-id
  nr-key = var.nr-key
}



# module "nexus-server" {
#   source        = "./modules/nexus-server"
#   redhat-ami-id = var.redhat-ami-id
#   domain-name   = var.domain-name
#   instance-type = var.instance-type
#   key-name      = var.key-name
#   subnet-id     = data.aws_subnet.public-subnet-1.id
#   nexus-sg-id   = module.security-groups.nexus-sg-id
# }

# module "bastion-host" {
#   source           = "./modules/bastion-host"
#   redhat-ami-id    = var.redhat-ami-id
#   instance-type    = var.instance-type
#   key-name         = var.key-name
#   bastion-sg       = var.bastion-sg
#   private_key_name = var.private_key_name
#   bastion-subnet   = data.aws_subnet.public-subnet-2.id
# }

# module "ansible-server" {
#   source                 = "./modules/ansible-server"
#   redhat-ami-id          = var.redhat-ami-id
#   instance-type          = var.instance-type
#   ssh-key-name           = var.ssh-key-name
#   public_subnet_id       = data.aws_subnet.private-subnet-1.id
#   ansible_sg             = module.security-groups.ansible-sg-id
#   stage-playbook         = var.stage-playbook
#   prod-playbook          = var.prod-playbook
#   stage-discovery-script = var.stage-discovery-script
#   prod-discovery-script  = var.prod-discovery-script
#   private_key            = var.private_key
#   nexus-ip               = module.nexus-server.public_ip
#   nr-key                 = var.nr-key
#   nr-acc-id              = var.nr-acc-id
#   nr-region              = var.nr-region
# }

# module "rds-database" {
#   source       = "./modules/rds-database"
#   db-subnet-id = [data.aws_subnet.private-subnet-1.id, data.aws_subnet.private-subnet-2.id, data.aws_subnet.private-subnet-3.id]
#   db-name      = var.db-name
#   db-username  = var.db-username
#   db-password  = var.db-password
#   vpc-sg-id    = module.security-groups.rds-sg-id
# }

# module "sonarqube-server" {
#   source              = "./modules/sonarqube-server"
#   ubuntu-ami-id       = var.ubuntu-ami-id
#   instance-type       = var.instance-type
#   key-name            = var.key-name
#   subnet-id           = data.aws_subnet.public-subnet-3.id
#   sonarqube-sg        = module.security-groups.sonarqube-sg-id
#   nr-key              = var.nr-key
#   nr-acc-id           = var.nr-acc-id
#   nr-region           = var.nr-region
#   elb-subnets         = var.elb-subnets
#   cert-arn            = var.cert-arn
#   sonar-postgress-pwd = var.sonar-postgress-pwd
#   sonar-psqldb-pwd    = var.sonar-psqldb-pwd
# }