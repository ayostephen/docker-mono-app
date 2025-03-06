locals {
  user_data = <<-EOF
    #!/bin/bash
    echo "Copying private key..."
    sudo mkdir -p /home/ec2-user/.ssh
    sudo cp /tmp/${var.private_key_name} /home/ec2-user/.ssh/
    sudo chmod 400 /home/ec2-user/.ssh/${var.private_key_name}
    sudo chown ec2-user:ec2-user /home/ec2-user/.ssh/${var.private_key_name}
    curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY="${var.nr-key}" NEW_RELIC_ACCOUNT_ID="${var.nr-acc-id}" NEW_RELIC_REGION="${var.nr-region}" /usr/local/bin/newrelic install -y
  EOF
}