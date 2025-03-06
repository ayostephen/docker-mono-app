resource "aws_instance" "nexus-server" {
  ami                         = var.redhat-ami-id
  instance_type               = var.instance-type
  key_name                    = var.key-name
  subnet_id                   = var.subnet-id
  vpc_security_group_ids      = var.nexus-sg-id
  associate_public_ip_address = true
  user_data                   = local.nexuscript
    metadata_options {
      http_tokens = "required"
    }
    root_block_device {
      volume_size = 50
      volume_type = "gp3"
      encrypted   = "true"
    }
  tags = {
    Name = "Nexus-Server"
  }
}
