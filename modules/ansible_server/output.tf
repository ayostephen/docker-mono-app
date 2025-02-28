output "ansible_server_private_ip" {
  description = "Private IP of the Ansible server"
  value       = aws_instance.ansible_server.private_ip
}
