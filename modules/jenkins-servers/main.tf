resource "aws_instance" "jenkins-slave-node" {
  ami                    = var.redhat-ami-id
  instance_type          = var.instance-type
  subnet_id              = var.subnet-id
  key_name               = var.key-name
  vpc_security_group_ids = [var.jenkins-sg]
  user_data              = local.jenkinscript
  associate_public_ip_address = true
  metadata_options {
    http_tokens = "required"
  }
  root_block_device {
    volume_size = 50
    volume_type = "gp3"
    encrypted   = "true"
  }
  tags = {
    Name = "jenkins-slave-node"
  }
}

resource "aws_instance" "jenkins-slave-cloud" {
  ami                    = var.ubuntu-ami-id
  instance_type          = var.instance-type
  subnet_id              = var.subnet-id
  key_name               = var.key-name
  vpc_security_group_ids = [var.jenkins-sg]
  user_data              = local.jenkins-docker-script
  associate_public_ip_address = true
  metadata_options {
    http_tokens = "required"
  }
  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "jenkins-slave-cloud"
  }
}
