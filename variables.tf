variable "region" {}
variable "profile" {}

## security-groups
variable "allowed_ssh_ips" {} # Restrict this IPs in production later if needed
variable "project-name" {}
variable "asg-port" {}
variable "nexus-port-1" {}
variable "nexus-port-2" {}
variable "sonar-port" {}
variable "rds-port" {}


# ###ansible_server
# variable "redhat-ami_id" {}
# variable "instance_type" {}
# variable "ssh_key_name" {}
# variable "public_subnet_id" {}
# variable "ansible_sg" {}
# variable "stage-playbook" {}
# variable "prod-playbook" {}
# variable "stage-discovery-script" {}
# variable "prod-discovery-script" {}
# variable "private_key" {}
# variable "nexus-ip" {}
# variable "nr-key" {}
# variable "nr-acc-id" {}
# variable "nr-region" {}

# ## bastion-host
# variable "redhat-ami-id" {}
# variable "instance-type" {}
# variable "key-name" {}
# variable "bastion-subnet" {}
# variable "bastion-sg" {}
# variable "private_key_name" {}

# # nexus server
# variable "redhat-ami-id" {}
# variable "domain-name" {}
# variable "instance-type" {}
# variable "key-name" {}
# variable "subnet-id" {}
# variable "nexus-sg-id" {}

# ## rds
# variable "db-subnet-id" {}
# variable "db-name" {}
# variable "db-username" {}
# variable "db-password" {}
# variable "vpc-sg-id" {}

# ## sonarqube server
# variable "ubuntu-ami_id" {}
# variable "instance_type" {}
# variable "key_name" {}
# variable "instance_name" {}
# variable "subnet_id" {}
# variable "sonarqube-sg" {}
# variable "nr-key" {}
# variable "nr-acc-id" {}
# variable "nr-region" {}
# variable "elb-subnets" {}
# variable "cert-arn" {}
# variable "sonar-postgress-pwd" {}
# variable "sonar-psqldb-pwd" {}


############
## Jenkins variables
variable "ami_id" {}
variable "instance_type" {}
# Not sure if we need both!
# variable "key_name" {}
# To be created in the default VPC and Subnet
# variable "subnet_id" {}
# variable "jenkins_sg" {}
# variable "nexus-ip" {}
variable "nr-region" {}
variable "nr-key" {}
variable "nr-acc-id" {}
# variable "subnet-elb" {}
# variable "cert-arn" {}
# variable "ami_ubuntu" {}