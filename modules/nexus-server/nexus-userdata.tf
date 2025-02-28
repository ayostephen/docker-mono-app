locals {
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install java-1.8.0-openjdk -y
    sudo useradd nexus
    sudo mkdir /opt/nexus
    sudo chown -R nexus:nexus /opt/nexus
    cd /opt/nexus
    sudo wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
    sudo tar -zxvf latest-unix.tar.gz
    sudo mv nexus-* nexus
    sudo chown -R nexus:nexus nexus
    echo "run_as_user=\"nexus\"" | sudo tee -a /opt/nexus/nexus/bin/nexus.rc
    sudo chmod +x /opt/nexus/nexus/bin/nexus
    sudo -u nexus /opt/nexus/nexus/bin/nexus start
  EOF

  tags = { Name = "Nexus-Server" }
}
