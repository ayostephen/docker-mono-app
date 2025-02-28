locals {
  user_data = <<-EOF
    #!/bin/bash
    echo "Copying private key..."
    sudo mkdir -p /home/ec2-user/.ssh
    sudo cp /tmp/${var.private_key_name} /home/ec2-user/.ssh/
    sudo chmod 400 /home/ec2-user/.ssh/${var.private_key_name}
    sudo chown ec2-user:ec2-user /home/ec2-user/.ssh/${var.private_key_name}
  EOF
}