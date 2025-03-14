
# Installing Jenkins on an ubuntu server
locals {
  jenkinscript = <<-EOF
#!/bin/bash
sudo yum update -y
sudo yum install git -y
sudo yum install maven -y
sudo yum install wget -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo yum install java-17-openjdk -y
sudo yum install jenkins -y
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y
sudo service docker start
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins
sudo chmod 777 /var/run/docker.sock

sudo systemctl restart docker

sudo mkdir /opt/build
sudo chmod 777 /opt/build

curl -sO https://jenkins.hullerdata.com/jnlpJars/agent.jar
sudo mv ~/agent.jar /opt && cd /opt
java -jar agent.jar -url http://jenkins.hullerdata.com/ -secret 5bdcd3aafaf20eb6a30aafd1e1c713f23983ef2a8e14bf7046253a3214251ef7 -name "jenkins-node" -webSocket -workDir "/opt/build"

curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY="${var.nr-key}" NEW_RELIC_ACCOUNT_ID="${var.nr-acc-id}" NEW_RELIC_REGION="${var.nr-region}" /usr/local/bin/newrelic install -y

sudo hostnamectl set-hostname jenkins
EOF  
}


######
# sudo cat <<EOT>> /etc/docker/daemon.json
# {
#   "insecure-registries" : ["${var.nexus-ip}:8085"]
# }
# EOT