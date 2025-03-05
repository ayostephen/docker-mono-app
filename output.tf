output "jenkins-node-public-ip" {
  value = module.jenkins-slaves.jenkins_public_ip
}

output "jenkins-cloud-public-ip" {
  value = module.jenkins-slaves.jenkins-docker-public_ip
}