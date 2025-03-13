#!/bin/bash

export virtualMachine=prod-jenkins-vm
export resourceGroup=nbaksclust-rg
# Jenkins

# Open port 80 to allow web traffic to host.
az vm open-port --port 80 --resource-group $resourceGroup --name $virtualMachine  --priority 101

# Open port 22 to allow ssh traffic to host.
az vm open-port --port 22 --resource-group $resourceGroup --name $virtualMachine --priority 102

# Open port 8080 to allow web traffic to host.
az vm open-port --port 8080 --resource-group $resourceGroup --name $virtualMachine --priority 103

sudo apt update

# Remove the old PPA
# sudo add-apt-repository --remove ppa:webupd8team/java

# Install OpenJDK 17
sudo apt update
sudo apt install -y openjdk-17-jdk

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
    https://pkg.jenkins.io/debian binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install fontconfig openjdk-17-jre
sudo apt-get install -y jenkins
# sudo apt-get update
# sudo apt-get install jenkins
# sudo ufw allow OpenSSH
# sudo ufw allow 22/tcp
# sudo ufw allow 443/tcp
# sudo ufw allow 80/tcp
# sudo ufw allow 8080/tcp
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# sudo ufw enable -y

# Docker
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce -y

# Azure CLI
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893
sudo apt-get install apt-transport-https
sudo apt-get update && sudo apt-get install azure-cli

# Kubectl
cd /tmp/
sudo curl -kLO https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Configure access
usermod -aG docker jenkins
usermod -aG docker azureuser
sudo touch /var/lib/jenkins/jenkins.install.InstallUtil.lastExecVersion
service jenkins restart