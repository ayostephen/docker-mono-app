output "bastion-host-public-ip" {
  value = aws_instance.bastion-host.public_ip
}
