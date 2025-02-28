resource "aws_instance" "jenkins" {
  count                  = var.count  
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.jenkins_sg] 
  metadata_options {
    http_tokens = "required"
  }  
  root_block_device {
    encrypted = true
  }
  user_data              = local.jenkinscript
  tags = {
    Name = "jenkins_slave-${count.index}"
  }
}


resource "aws_elb" "jenkins_lb" {
  count = var.count
  name            = "jenkins-lb-${count.index}"
  subnets         = var.subnet-elb
  security_groups = [var.jenkins_sg]
  listener {
    instance_port      = 8080
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.cert-arn
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8080"
    interval            = 30
  }

  instances                   = [aws_instance.jenkins.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "jenkins-elb-${count.index}"
  }

}
