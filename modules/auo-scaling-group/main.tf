# Creating Load Balancer for ASG Stage

resource "aws_lb" "stage-asg-lb" {
  name               = ""
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb-sg.id]  # Ensure a security group allows HTTP/HTTPS
  subnets            = aws_subnet.public[*].id        # Attach to public subnets

  enable_deletion_protection = false

  tags = {
    Name = "Stage-ASG-LoadBalancer"
  }
}

## HTTP Listener
resource "aws_lb_listener" "stage-http-listener" {
  load_balancer_arn = aws_lb.asg-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

## HTTPS Listener
resource "aws_lb_listener" "stage-https-listener" {
  load_balancer_arn = aws_lb.asg-lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn  # Replace with actual certificate ARN

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_target_group.arn
  }
}

## Creating a target group for stage ASG
resource "aws_lb_target_group" "stage-asg-target-group" {
  name        = "asg-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id  # Replace with your actual VPC ID
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "ASG-TargetGroup"
  }
}

### Attaching target group to stage ASG
# Ensures EC2 instances from the ASG are automatically added to the Target Group.
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  lb_target_group_arn    = aws_lb_target_group.stage-asg-target-group.arn
}
