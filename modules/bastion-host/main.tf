resource "aws_instance" "bastion-host" {
  ami                         = var.redhat-ami-id
  instance_type               = var.instance-type
  key_name                    = var.key-name
  vpc_security_group_ids      = var.bastion-sg
  subnet_id                   = var.bastion-subnet
  associate_public_ip_address = true
  user_data_base64            = local.user_data
  metadata_options {
    http_tokens = "required"
  }
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = "true"
  }
  tags = {
    Name = "Bastion-Host"
  }
}
