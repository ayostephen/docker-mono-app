locals {
  name                = "auto-discovery-mono-app"
    jenkins-sg-id = "sg-084f1c96d276ca271"
    jenkins_public_ip = "18.130.58.97"
    private_subnet_id-1 = "subnet-061d6de26b1036ea9"
    private_subnet_id-2 = "subnet-0d36b97fa34e9faa6"
    private_subnet_id-3 = "subnet-0fb822845ea552573"
    public_subnet_id-1 = "subnet-02a68e9f1ba404241"
    public_subnet_id-2 = "subnet-030192940885e76fe"
    public_subnet_id-3 = "subnet-0234c04380cceefa4"
    vault_public_ip = "13.40.46.166"
    vpc_id = "vpc-01257239fdc2048e7"
    cert-arn = ""
}

# AWS_VPC 
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

data "aws_acm_certificate" "cert-arn" {
  arn = local.cert-arn
}

# data "aws_security_group" "bastion-sg" {
#   id = local.bastion_sg
# }

module "security-groups" {
  source            = "./modules/security-groups"
  vpc-id            = data.aws_vpc.vpc.id
  allowed-ssh-ips   = var.allowed-ssh-ips
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
  source          = "./modules/jenkins-servers"
  redhat-ami-id   = var.redhat-ami-id
  ubuntu-ami-id   = var.ubuntu-ami-id
  instance-type   = var.instance-type
  key-name        = module.keypair.infra-pub-key
  subnet-id       = data.aws_subnet.public-subnet-1.id
  jenkins-sg      = data.aws_security_group.jenkins-sg.id
  nr-region       = var.nr-region
  nr-acc-id       = var.nr-acc-id
  nr-key          = var.nr-key
}



module "nexus-server" {
  source          = "./modules/nexus-server"
  redhat-ami-id   = var.redhat-ami-id
  public-subnets  = var.public-subnets
  domain-name     = var.domain-name
  instance-type   = var.instance-type
  key-name        = var.key-name
  subnet-id       = data.aws_subnet.public-subnet-1.id
  nexus-sg-id     = module.security-groups.nexus-sg-id
  nr-region       = var.nr-region
  nr-acc-id       = var.nr-acc-id
  nr-key          = var.nr-key
  nexus-ip        = var.nexus-ip
  # ssl-cert-id     = var.ssl-cert-id 
}

module "bastion-host" {
  source           = "./modules/bastion-host"
  redhat-ami-id    = var.redhat-ami-id
  instance-type    = var.instance-type
  key-name         = var.key-name
  bastion-sg       = var.bastion-sg
  private-key-name = var.private-key-name
  bastion-subnet   = data.aws_subnet.public-subnet-2.id
  nr-key           = var.nr-key
  nr-acc-id        = var.nr-acc-id
  nr-region        = var.nr-region
}

module "ansible-server" {
  source                 = "./modules/ansible-server"
  redhat-ami-id          = var.redhat-ami-id
  instance-type          = var.instance-type
  ssh-key-name           = var.ssh-key-name
  public-subnet-id       = data.aws_subnet.private-subnet-1.id
  ansible-sg             = module.security-groups.ansible-sg-id
  stage-playbook         = "${path.root}/modules/ansible-server/stage-playbook.yaml"
  prod-playbook          = "${path.root}/modules/ansible-server/prod-playbook.yaml"
  stage-discovery-script = "${path.root}/modules/ansible-server/stage-autodiscovery.sh"
  prod-discovery-script  = "${path.root}/modules/ansible-server/prod-autodiscovery.sh"
  private-key            = var.private-key
  nexus-ip               = module.nexus-server.public_ip
  nr-key                 = var.nr-key
  nr-acc-id              = var.nr-acc-id
  nr-region              = var.nr-region
}


module "rds-database" {
  source       = "./modules/rds-database"
  db-subnet-id = [data.aws_subnet.private-subnet-1.id, data.aws_subnet.private-subnet-2.id, data.aws_subnet.private-subnet-3.id]
  db-name      = var.db-name
  db-username  = var.db-username
  db-password  = var.db-password
  vpc-sg-id    = module.security-groups.rds-sg-id
}

module "sonarqube-server" {
  source              = "./modules/sonarqube-server"
  ubuntu-ami-id       = var.ubuntu-ami-id
  public-subnets      = var.public-subnets
  instance-type       = var.instance-type
  key-name            = var.key-name
  subnet-id           = data.aws_subnet.public-subnet-3.id
  sonarqube-sg        = module.security-groups.sonarqube-sg-id
  nr-key              = var.nr-key
  nr-acc-id           = var.nr-acc-id
  nr-region           = var.nr-region
  elb-subnets         = var.elb-subnets
  cert-arn            = var.cert-arn
  sonar-postgress-pwd = var.sonar-postgress-pwd
  sonar-psqldb-pwd    = var.sonar-psqldb-pwd
}

module "stage-alb" {
  source = "./modules/stage-alb"
  alb-name-stage = "${local.name}-stage-alb"
  asg-sg =  module.security-groups.asg-sg-id
  public-subnets = [data.aws_subnet.public-subnet-1.id, data.aws_subnet.public-subnet-2.id, data.aws_subnet.public-subnet-3.id]
  cert-arn = var.cert-arn
  vpc-id = data.aws_vpc.vpc
}

module "prod-alb" {
  source = "./modules/prod-alb"
  alb-name-prod = "${local.name}-prod-alb"
  asg-sg =  module.security-groups.asg-sg-id
  public-subnets = [data.aws_subnet.public-subnet-1.id, data.aws_subnet.public-subnet-2.id, data.aws_subnet.public-subnet-3.id]
  cert-arn = var.cert-arn
  vpc-id = data.aws_vpc.vpc
}

module "records" {
  source = "./modules/records"
  domain-name = var.domain-name
  prod-domain-name = var.prod-domain-name
  prod-dns-name = var.prod-dns-name
  prod-zone-id = var.prod-zone-id
  stage-domain-name = var.stage-domain-name
  stage-dns-name = var.stage-dns-name
  stage-zone-id = var.stage-zone-id
  sonarqube-domain-name = var.sonarqube-domain-name
  sonarqube-dns-name = var.sonarqube-dns-name
  sonarqube-zone-id = var.sonarqube-zone-id
  nexus-domain-name = var.nexus-domain-name
  nexus-dns-name = var.nexus-dns-name
  nexus-zone-id = var.nexus-zone-id
}