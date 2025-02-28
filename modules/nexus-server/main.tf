resource "aws_instance" "nexus-server" {
  ami                         = var.redhat-ami-id
  instance_type               = var.instance-type
  key_name                    = var.key-name
  subnet_id                   = var.subnet-id
  vpc_security_group_ids      = var.nexus-sg-id
  associate_public_ip_address = true
  user_data                   = local.user_data
  
  tags = {
    Name = "Nexus-Server"
  }
}
