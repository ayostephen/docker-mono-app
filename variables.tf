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

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  default     = true
}

variable "enable_vpn_gateway" {
  description = "Enable VPN Gateway"
  default     = true
}

variable "key_name" {
  description = "AWS Key Pair name"
  default     = "auto-dis-key"
}

variable "allowed_ssh_ips" {
  description = "Allowed SSH IPs"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Restrict this IPs in production later if needed
}

variable "allowed_rds_private_cidrs" {
  description = "Allowed private subnet CIDR blocks for RDS access"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]  # Example private subnet CIDRs
}
