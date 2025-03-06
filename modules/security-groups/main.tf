##Security Gropus
# Creating security group for asg
resource "aws_security_group" "asg-sg" {
  name        = "${var.project-name}-asg-sg"
  vpc_id      = var.vpc-id
  description = "security group for asg"

  ingress {
    description = "allow ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_ips
  }

  ingress {
    description = "allow asg-port access"
    from_port   = var.asg-port
    to_port     = var.asg-port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all traffic out"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project-name}-asg-sg"
  }
}

# Creating security group for nexus
resource "aws_security_group" "nexus-sg" {
  name        = "${var.project-name}-nexus-sg"
  vpc_id      = var.vpc-id
  description = "security group for nexus"

  ingress {
    description = "allow ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_ips
  }

  ingress {
    description = "allow http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_ips
  }


  ingress {
    description = "nexus-port 1" #to access nexus UI
    from_port   = var.nexus-port-1
    to_port     = var.nexus-port-1
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "nexus-port 2" #to access docker repo via nexus
    from_port   = var.nexus-port-2
    to_port     = var.nexus-port-2
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project-name}-nexus-sg"
  }
}

## Creating security group for RDS
resource "aws_security_group" "rds-sg" {
  name        = "${var.project-name}-rds-sg"
  vpc_id      = var.vpc-id
  description = "security group for RDS"

  ingress {
    description     = "MySQL access"
    from_port       = var.rds-port
    to_port         = var.rds-port
    protocol        = "tcp"
    security_groups = [aws_security_group.asg-sg.id, aws_security_group.ansible-bastion-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project-name}-rds-sg"
  }
}

# Creating security group for Ansible and Bastion Host
resource "aws_security_group" "ansible-bastion-sg" {
  name        = "${var.project-name}-ansible-sg"
  vpc_id      = var.vpc-id
  description = "security group for ansible and bastion host"

  ingress {
    description = "allow ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project-name}-ansible-sg"
  }
}
