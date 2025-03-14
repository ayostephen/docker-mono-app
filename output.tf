output "jenkins-node-public-ip" {
  value = module.jenkins-slaves.jenkins_public_ip
}

output "jenkins-cloud-public-ip" {
  value = module.jenkins-slaves.jenkins-docker-public_ip
}

output "nexus-public-ip" {
  value = module.nexus-server.nexus_server_public_ip
}
output "sonarqube-public-ip" {
  value = module.sonarqube-server.sonarqube_public_ip
}

output "ansible-private-ip" {
  value = module.ansible-server.ansible_server_private_ip
}

output "bastion-host-ip" {
  value = module.bastion-host.bastion-host-ip
}

output "rds-endpoint" {
  value = module.rds-database.rds_endpoint
}
