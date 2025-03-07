resource "aws_instance" "nexus-server" {
  #checkov:skip=CKV_AWS_135: Optimazation will be enfored on the stage/production environment
  #checkov:skip=CKV_AWS_126: detailed monitoring will be enfored on the stage/production environment
  #checkov:skip=CKV_AWS_88: using public ip for testing purposes, it will be enfored on the stage/production environment
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
