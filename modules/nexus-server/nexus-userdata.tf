locals {
  nexuscript = <<-EOF
#!/bin/bash
# Update system and install dependencies
sudo yum update -y
sudo yum install wget unzip java-1.8.0-openjdk.x86_64 -y
sudo hostnamectl set-hostname Nexus

# Create installation directory and download Nexus
sudo mkdir -p /opt && cd /opt
sudo wget http://download.sonatype.com/nexus/3/nexus-3.70.3-01-unix.tar.gz

# Extract and move Nexus files to the correct directory
sudo tar -xvf nexus-3.70.3-01-unix.tar.gz
sudo mv nexus-3.70.3-01 nexus

# Clean up the tarball
sudo rm -f nexus-3.70.3-01-unix.tar.gz

# Create 'nexus' user and set permissions
sudo adduser nexus
sudo chown -R nexus:nexus /opt/nexus
sudo mkdir -p /opt/sonatype-work
sudo chown -R nexus:nexus /opt/sonatype-work

# Configure Nexus to run as 'nexus' user
sudo cat <<EOT > /opt/nexus/bin/nexus.rc
run_as_user="nexus"
EOT

# Memory optimization for Nexus
sudo sed -i '2s/-Xms2703m/-Xms512m/' /opt/nexus/bin/nexus.vmoptions
sudo sed -i '3s/-Xmx2703m/-Xmx512m/' /opt/nexus/bin/nexus.vmoptions
sudo sed -i '4s/-XX:MaxDirectMemorySize=2703m/-XX:MaxDirectMemorySize=512m/' /opt/nexus/bin/nexus.vmoptions

# Create systemd service for Nexus
sudo cat <<EOT > /etc/systemd/system/nexus.service
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOT

# Reload systemd to recognize the new Nexus service
sudo systemctl daemon-reload

# Enable and start Nexus service
sudo systemctl enable nexus
sudo systemctl start nexus

# Check the status of Nexus service
sudo systemctl status nexus

# End of script
echo "Nexus installation completed successfully."
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY="${var.nr-key}" NEW_RELIC_ACCOUNT_ID="${var.nr-acc-id}" NEW_RELIC_REGION="${var.nr-region}" /usr/local/bin/newrelic install -y
EOF
}




# locals {
#   nexuscript = <<-EOF
# #!/bin/bash
# sudo yum update -y
# sudo yum install wget -y
# sudo yum install java-1.8.0-openjdk.x86_64 -y
# sudo mkdir /app && cd /app
# sudo wget http://download.sonatype.com/nexus/3/nexus-3.70.3-01-unix.tar.gz
# sudo tar -xvf nexus-3.70.3-01-unix.tar.gz
# sudo mv nexus-3.70.3-01 nexus
# sudo adduser nexus
# sudo chown -R nexus:nexus /app/nexus
# sudo chown -R nexus:nexus /app/sonatype-work
# sudo cat <<EOT> /app/nexus/bin/nexus.rc
# run_as_user="nexus"
# EOT
# sed -i '2s/-Xms2703m/-Xms512m/' /app/nexus/bin/nexus.vmoptions
# sed -i '3s/-Xmx2703m/-Xmx512m/' /app/nexus/bin/nexus.vmoptions
# sed -i '4s/-XX:MaxDirectMemorySize=2703m/-XX:MaxDirectMemorySize=512m/' /app/nexus/bin/nexus.vmoptions
# sudo touch /etc/systemd/system/nexus.service
# sudo cat <<EOT> /etc/systemd/system/nexus.service
# [Unit]
# Description=nexus service
# After=network.target
# [Service]
# Type=forking
# LimitNOFILE=65536
# User=nexus
# Group=nexus
# ExecStart=/app/nexus/bin/nexus start
# ExecStop=/app/nexus/bin/nexus stop
# User=nexus
# Restart=on-abort
# [Install]
# WantedBy=multi-user.target
# EOT
# sudo ln -s /app/nexus/bin/nexus /etc/init.d/nexus
# sudo chkconfig --add nexus
# sudo chkconfig --levels 345 nexus on
# sudo service nexus start
# curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY="${var.nr-key}" NEW_RELIC_ACCOUNT_ID="${var.nr-acc-id}" NEW_RELIC_REGION="${var.nr-region}" /usr/local/bin/newrelic install -y
# sudo hostnamectl set-hostname Nexus
# EOF
# }