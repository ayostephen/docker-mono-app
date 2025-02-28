# Create Ansible Server (EC2 Instance)
resource "aws_instance" "ansible_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [var.ansible_sg]
  subnet_id              = var.public_subnet_id

  user_data = local.ansible-user-data
  metadata_options {
    http_tokens = "required"
  }
  root_block_device {
    volume_size = 40
    volume_type = "gp3"
    encrypted = "true"
  }
  tags = {
    Name = "AnsibleServer"
  }
}
