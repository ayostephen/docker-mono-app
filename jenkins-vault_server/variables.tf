##########################
# Jenkins-Vault-Server
variable "region" {
  default = "eu-west-2"
}

variable "profile" {
  default = "mchall"
}
variable "ami-ubuntu" {
  default = "ami-04da26f654d3383cf" #Ubuntu 22.04 ami for Vault server
}
variable "domain-name" {
  default = "sternwatch.com"
}
variable "domain-names" {
  default = "*.sternwatch.com"
}
variable "vault-domain-name" {
  default = "vault.sternwatch.com"
}
variable "jenkins-domain-name" {
  default = "jenkins.sternwatch.com"
}
variable "redhat_ami_id" {
  default = "ami-0727cf12519cc2b5b" #Redhat Linux 9 ami for jenkins server
}

variable "instance_type" {
  default = "t2.medium"
}

##############################
## VPC
variable "vpc-name" {
  description = "The name of the VPC"
  type        = string
  default     = "auto-discovery-vpc"
}

variable "vpc-cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}
variable "private-subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}
variable "public-subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

###########################
# Securtiy group
variable "allowed-ssh-ips" {
  description = "A list of IP addresses that are allowed to SSH into the Vault server"
  type        = list(string)
  default     = ["82.219.0.0/16", "10.0.0.0/16", ]
}

variable "nr-key" {
  description = "New Relic API key"
  type        = string
  default     = "NRAK-B8R254VSC3TQ1DH7FTZURMJ57HO"
}

variable "nr-acc-id" {
  description = "New Relic account ID"
  type        = string
  default     = "6700591"
}
variable "nr-region" {
  description = "New Relic region"
  type        = string
  default     = "eu"
}