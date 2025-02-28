# Output values
output "vault_public_ip" {
  value = aws_instance.vault.public_ip
}

output "jenkins_public_ip" {
  description = "Public IP of the jenkins host"
  value       = aws_instance.jenkins.public_ip
}

output "jenkins-sg-id" {
  value = aws_security_group.jenkins-sg.id 
}

output "jenkins-key" {
  value = aws_key_pair.vault_pair.key_name
}

####################
output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The ID of the VPC"
}

output "public_subnet_id-1" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids[0]
}

output "public_subnet_id-2" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids[1]
}

output "public_subnet_id-3" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids[2]
}

output "private_subnet_id-1" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids[0]
}

output "private_subnet_id-2" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids[1]
}

output "private_subnet_id-3" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids[2]
}