# Output values
output "vault_public_ip" {
  value = aws_instance.vault.public_ip
}

# output "jenkins_public_ip" {
#   description = "Public IP of the jenkins host"
#   value       = aws_instance.jenkins.public_ip
# }

