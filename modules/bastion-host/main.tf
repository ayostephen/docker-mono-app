resource "aws_instance" "bastion-host" {
  ami                         = var.redhat-ami-id
  instance_type               = var.instance-type
  key_name                    = var.key-name
  vpc_security_group_ids      = var.bastion-sg
  subnet_id                   = var.bastion-subnet
  associate_public_ip_address = true
  user_data_base64            = local.user_data

  tags = {
    Name = "Bastion-Host"
  }
}
