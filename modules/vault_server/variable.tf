variable "region" {
  default = "eu-west-2"
}

variable "ami-ubuntu" {
  default = "ami-091f18e98bc129c4e"
}
variable "domain-name" {
  default = "hullerdata.com"
}
variable "domain-names" {
  default = "*.hullerdata.com"
}
variable "vault-domain-name" {
  default = "vault.hullerdata.com"
}
variable "ami_id" {
  default = "ami-0f9535ac605dc21d5"
}

variable "instance_type" {
  default = "t2.medium"
}
