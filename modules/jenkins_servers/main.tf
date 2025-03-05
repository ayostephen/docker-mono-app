resource "aws_instance" "jenkins-slave-node" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.jenkins_sg]
  user_data              = local.jenkinscript
  associate_public_ip_address = true
  metadata_options {
    http_tokens = "required"
  }
  root_block_device {
    encrypted = true
  }
  tags = {
    Name = "jenkins-slave-node"
  }
}

resource "aws_instance" "jenkins-slave-cloud" {
  ami                    = var.ami_ubuntu
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.jenkins-cloud-sg]
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
