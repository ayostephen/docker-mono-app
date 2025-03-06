# ##########################
# # Output for ASG Security Group
# output "asg_sg_id" {
#   description = "Security Group ID for ASG"
#   value       = aws_security_group.asg-sg.id
# }

# output "asg_sg_name" {
#   description = "Security Group Name for ASG"
#   value       = aws_security_group.asg-sg.name
# }

# # Output for Nexus Security Group
# output "nexus_sg_id" {
#   description = "Security Group ID for Nexus"
#   value       = aws_security_group.nexus-sg.id
# }

# output "nexus_sg_name" {
#   description = "Security Group Name for Nexus"
#   value       = aws_security_group.nexus-sg.name
# }

# # Output for Ansible & Bastion Host Security Group
# output "ansible_bastion_sg_id" {
#   description = "Security Group ID for Ansible & Bastion Host"
#   value       = aws_security_group.ansible-bastion-sg.id
# }

# output "ansible_bastion_sg_name" {
#   description = "Security Group Name for Ansible & Bastion Host"
#   value       = aws_security_group.ansible-bastion-sg.name
# }

# # Output for RDS Security Group
# output "rds_sg_id" {
#   description = "Security Group ID for RDS"
#   value       = aws_security_group.rds-sg.id
# }

# output "rds_sg_name" {
#   description = "Security Group Name for RDS"
#   value       = aws_security_group.rds-sg.name
# }

# Output for Jenkins-Docker Security Group
output "jenkins_docker_sg_id" {
  description = "Security Group ID for Jenkins-Docker"
  value       = aws_security_group.jenkins-docker-sg.id
}

# output "jenkins-node-sg" {
#   description = "Security Group Name for Jenkins-slave-node"
#   value       = aws_security_group.jenkins-docker-sg.name
# }
