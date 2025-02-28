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