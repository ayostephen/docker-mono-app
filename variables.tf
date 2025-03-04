variable "aws_region" {
  description = "AWS region"
  default     = "eu-west-2" // Change this to your desired region
}

variable "profile" {
  description = "AWS Profile"
  //profile = "default" // Uncomment this line when named profile is available to use
}

variable "vpc_name" {
  description = "Name of the VPC"
  default     = "auto-discovery-mono-app-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "enable_nat_gateway" {}
variable "enable_vpn_gateway" {}
variable "key_name" {}
variable "allowed_ssh_ips" {} # Restrict this IPs in production later if needed
variable "vpc_cidr" {}
variable "project-name" {}
variable "asg-port" {}
variable "nexus-port-1" {}
variable "nexus-port-2" {}
variable "sonar-port" {}
variable "rds-port" {}
variable "vpc-id" {}

###ansible_server
variable "redhat-ami_id" {}
variable "instance_type" {}
variable "ssh_key_name" {}
variable "public_subnet_id" {}
variable "ansible_sg" {}
variable "stage-playbook" {}
variable "prod-playbook" {}
variable "stage-discovery-script" {}
variable "prod-discovery-script" {}
variable "private_key" {}
variable "nexus-ip" {}
variable "nr-key" {}
variable "nr-acc-id" {}
variable "nr-region" {}

## bastion-host
variable "redhat-ami-id" {}
variable "instance-type" {}
variable "key-name" {}
variable "bastion-subnet" {}
variable "bastion-sg" {}
variable "private_key_name" {}

## Jenkins Servers
variable "ami_id" {}
variable "count" {}
variable "instance_type" {}
# Not sure if we need both!
variable "private_key" {}
variable "key_name" {}
variable "instance_name" {}
# To be created in the default VPC and Subnet
variable "subnet_id" {}
variable "jenkins_sg" {}
variable "nexus-ip" {}
variable "nr-region" {}
variable "nr-key" {}
variable "nr-acc-id" {}
variable "subnet-elb" {}
variable "cert-arn" {}

# nexus server
variable "redhat-ami-id" {}
variable "domain-name" {}
variable "instance-type" {}
variable "key-name" {}
variable "subnet-id" {}
variable "nexus-sg-id" {}

## rds
variable "db-subnet-id" {}
variable "db-name" {}
variable "db-username" {}
variable "db-password" {}
variable "vpc-sg-id" {}

## security-groups
variable "allowed_ssh_ips" {} # Restrict this IPs in production later if needed
variable "vpc_cidr" {}
variable "project-name" {}
variable "asg-port" {}
variable "nexus-port-1" {}
variable "nexus-port-2" {}
variable "sonar-port" {}
variable "rds-port" {}
variable "vpc-id" {}
variable "jenkins-master-sg" {}

## sonarqube server
variable "ubuntu-ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "instance_name" {}
variable "subnet_id" {}
variable "sonarqube-sg" {}
variable "nr-key" {}
variable "nr-acc-id" {}
variable "nr-region" {}
variable "elb-subnets" {}
variable "cert-arn" {}
variable "sonar-postgress-pwd" {}
variable "sonar-psqldb-pwd" {}
