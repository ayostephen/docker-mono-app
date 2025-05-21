locals {

  name                = "auto-discovery-mono-app" # Name of the project

  cert-arn = "arn:aws:acm:eu-west-2:288761743690:certificate/26d00495-d752-4284-a8f2-00a6403c68ac"
  jenkins-public-ip = "18.130.225.172"
  jenkins-sg-id = "sg-075e243c9643ab993"
  private-subnet-id-1 = "subnet-052d26b63c114a07d"
  private-subnet-id-2 = "subnet-01af2a5abd774df0b"
  private-subnet-id-3 = "subnet-0187a3bc3daaba1f5"
  public-subnet-id-1 = "subnet-0ec775aa24f5427e4"
  public-subnet-id-2 = "subnet-009be4dcd38dbea3f"
  public-subnet-id-3 = "subnet-05a8b6ee9c5699f6b"
  vault-public-ip = "13.40.168.221"
  vpc-id = "vpc-0654a34ab5632236a"

}

# AWS_VPC 
data "aws_vpc" "vpc" {
  id = local.vpc-id
}

data "aws_subnet" "public-subnet-1" {
  id = local.public-subnet-id-1
}

data "aws_subnet" "public-subnet-2" {
  id = local.public-subnet-id-2
}

data "aws_subnet" "public-subnet-3" {
  id = local.public-subnet-id-3
}

data "aws_subnet" "private-subnet-1" {
  id = local.private-subnet-id-1
}

data "aws_subnet" "private-subnet-2" {
  id = local.private-subnet-id-2
}

data "aws_subnet" "private-subnet-3" {
  id = local.private-subnet-id-3
}

data "aws_security_group" "jenkins-sg" {
  id = local.jenkins-sg-id
}

data "aws_acm_certificate" "cert-arn" {
  domain      = var.domain-name
  types       = ["AMAZON_ISSUED"]
  most_recent = true
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
  source        = "./modules/jenkins-servers"
  redhat-ami-id = var.redhat-ami-id
  ubuntu-ami-id = var.ubuntu-ami-id
  instance-type = var.instance-type
  key-name      = module.keypair.infra-pub-key
  subnet-id     = data.aws_subnet.public-subnet-1.id
  jenkins-sg    = data.aws_security_group.jenkins-sg.id
  nexus-ip      = module.nexus-server.nexus-server-public-ip
  nr-region     = var.nr-region
  nr-acc-id     = var.nr-acc-id
  nr-key        = var.nr-key
  nexus-pri-ip  = module.nexus-server.nexus-server-private-ip
}

module "nexus-server" {
  source         = "./modules/nexus-server"
  redhat-ami-id  = var.redhat-ami-id
  public-subnets = [data.aws_subnet.public-subnet-1.id, data.aws_subnet.public-subnet-2.id]
  instance-type  = var.instance-type
  key-name       = module.keypair.infra-pub-key
  subnet-id      = data.aws_subnet.public-subnet-1.id
  nexus-sg-id    = [module.security-groups.nexus-sg-id]
  nr-region      = var.nr-region
  nr-acc-id      = var.nr-acc-id
  nr-key         = var.nr-key
  ssl-cert-id    = data.aws_acm_certificate.cert-arn.arn
}

module "bastion-host" {
  source           = "./modules/bastion-host"
  redhat-ami-id    = var.redhat-ami-id
  instance-type    = var.instance-type
  key-name         = module.keypair.infra-pub-key
  bastion-sg       = [module.security-groups.ansible-bastion-sg-id]
  private-key-name = module.keypair.infra-private-key
  bastion-subnet   = data.aws_subnet.public-subnet-2.id
  nr-key           = var.nr-key
  nr-acc-id        = var.nr-acc-id
  nr-region        = var.nr-region
}

module "ansible-server" {
  source                 = "./modules/ansible-server"
  redhat-ami-id          = var.redhat-ami-id
  instance-type          = var.instance-type
  ssh-key-name           = module.keypair.infra-pub-key
  public-subnet-id       = data.aws_subnet.private-subnet-1.id
  ansible-sg             = module.security-groups.ansible-bastion-sg-id
  stage-playbook         = "${path.root}/modules/ansible-server/stage-playbook.yaml"
  prod-playbook          = "${path.root}/modules/ansible-server/prod-playbook.yaml"
  stage-discovery-script = "${path.root}/modules/ansible-server/stage-autodiscovery.sh"
  prod-discovery-script  = "${path.root}/modules/ansible-server/prod-autodiscovery.sh"
  private-key            = module.keypair.infra-private-key
  nexus-ip               = module.nexus-server.nexus-server-public-ip
  nr-key                 = var.nr-key
  nr-acc-id              = var.nr-acc-id
  nr-region              = var.nr-region
}

data "vault_generic_secret" "db-secret" {
  path = "secret/database"
}

module "rds-database" {
  source       = "./modules/rds-database"
  db-subnet-id = [data.aws_subnet.private-subnet-1.id, data.aws_subnet.private-subnet-2.id, data.aws_subnet.private-subnet-3.id]
  db-name      = var.db-name
  db-username  = data.vault_generic_secret.db-secret.data["username"]
  db-password  = data.vault_generic_secret.db-secret.data["password"]
  vpc-sg-id    = [module.security-groups.rds-sg-id]
}

module "sonarqube-server" {
  source              = "./modules/sonarqube-server"
  ubuntu-ami-id       = var.ubuntu-ami-id
  public-subnets      = [data.aws_subnet.public-subnet-2.id, data.aws_subnet.public-subnet-3.id]
  instance-type       = var.instance-type
  key-name            = module.keypair.infra-pub-key
  subnet-id           = data.aws_subnet.public-subnet-2.id
  sonarqube-sg        = module.security-groups.sonarqube-id
  nr-key              = var.nr-key
  nr-acc-id           = var.nr-acc-id
  nr-region           = var.nr-region
  cert-arn            = data.aws_acm_certificate.cert-arn.arn
  sonar-postgress-pwd = var.sonar-postgress-pwd
  sonar-psqldb-pwd    = var.sonar-psqldb-pwd
}

module "stage-alb" {
  source         = "./modules/stage-alb"
  alb-name-stage = "stage-alb"
  asg-sg         = [module.security-groups.asg-sg-id]
  public-subnets = [data.aws_subnet.public-subnet-1.id, data.aws_subnet.public-subnet-2.id, data.aws_subnet.public-subnet-3.id]
  cert-arn       = data.aws_acm_certificate.cert-arn.arn
  vpc-id         = data.aws_vpc.vpc.id
}

module "prod-alb" {
  source         = "./modules/prod-alb"
  alb-name-prod  = "prod-alb"
  asg-sg         = [module.security-groups.asg-sg-id]
  public-subnets = [data.aws_subnet.public-subnet-1.id, data.aws_subnet.public-subnet-2.id, data.aws_subnet.public-subnet-3.id]
  cert-arn       = data.aws_acm_certificate.cert-arn.arn
  vpc-id         = data.aws_vpc.vpc.id
}

module "records" {
  source                = "./modules/records"
  domain-name           = var.domain-name
  prod-domain-name      = var.prod-domain-name
  prod-dns-name         = module.prod-alb.prod_lb_dns_name
  prod-zone-id          = module.prod-alb.prod_lb_zone_id
  stage-domain-name     = var.stage-domain-name
  stage-dns-name        = module.stage-alb.stage_lb_dns_name
  stage-zone-id         = module.stage-alb.stage_lb_zone_id
  sonarqube-domain-name = var.sonarqube-domain-name
  sonarqube-dns-name    = module.sonarqube-server.sonarqube-lb-dns-name
  sonarqube-zone-id     = module.sonarqube-server.sonarqube-lb-zone-id
  nexus-domain-name     = var.nexus-domain-name
  nexus-dns-name        = module.nexus-server.nexus-lb-dns-name
  nexus-zone-id         = module.nexus-server.nexus-lb-zone-id
}


module "prod-asg" {
  source              = "./modules/prod-asg"
  pub-key             = module.keypair.infra-pub-key
  nexus-ip-prd        = module.nexus-server.nexus-server-public-ip
  nr-acc-id           = var.nr-acc-id
  nr-key              = var.nr-key
  nr-region           = var.nr-region
  asg-prd-name        = "${local.name}-prod-asg"
  vpc-zone-identifier = [data.aws_subnet.private-subnet-2.id, data.aws_subnet.private-subnet-3.id]
  tg-prod             = module.prod-alb.prod-tg-arn
  redhat              = var.redhat-ami-id
  prod-sg             = [module.security-groups.asg-sg-id]
}

module "stage-asg" {
  source              = "./modules/stage-asg"
  pub-key             = module.keypair.infra-pub-key
  nexus-ip-stage      = module.nexus-server.nexus-server-public-ip
  nr-acc-id           = var.nr-acc-id
  nr-key              = var.nr-key
  nr-region           = var.nr-region
  asg-stage-name      = "${local.name}-stage-asg"
  vpc-zone-identifier = [data.aws_subnet.private-subnet-1.id, data.aws_subnet.private-subnet-2.id]
  tg-stage            = module.stage-alb.stage-tg-arn
  redhat              = var.redhat-ami-id
  stage-sg            = [module.security-groups.asg-sg-id]
}
