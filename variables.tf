########################
variable "region" {}
variable "profile" {}
variable "project-name" {}
variable "domain-name" {}
variable "key-name" {}
variable "subnet-id" {}
variable "instance-type" {}
variable "nexus-ip" {}

## security-groups
variable "allowed-ssh-ips" {} # Restrict this IPs in production later if needed
variable "asg-port" {}
variable "nexus-port-1" {}
variable "nexus-port-2" {}
variable "sonar-port" {}
variable "rds-port" {}

## AMIs
variable "redhat-ami-id" {}
variable "ubuntu-ami-id" {}

# # nexus server
variable "nexus-sg-id" {}
variable "nexus-ip" {}

## New Relic
variable "nr-region" {}
variable "nr-key" {}
variable "nr-acc-id" {}


#############
variable "db-name" {}
variable "db-username" {}
variable "db-password" {}


## bastion-host
variable "instance-type" {}
variable "key-name" {}
variable "bastion-subnet" {}
variable "bastion-sg" {}
variable "private-key-name" {}

#ansible_server
variable "ssh-key-name" {}
variable "public-subnet-id" {}
variable "ansible-sg" {}
variable "stage-playbook" {}
variable "prod-playbook" {}
variable "stage-discovery-script" {}
variable "prod-discovery-script" {}


### RDS
variable "db-subnet-id" {}
variable "vpc-sg-id" {}

## sonarqube server
variable "subnet-id" {}
variable "sonarqube-sg" {}
variable "elb-subnets" {}
variable "cert-arn" {}
variable "sonar-postgress-pwd" {}
variable "sonar-psqldb-pwd" {}
