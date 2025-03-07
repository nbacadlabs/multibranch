#!/bin/bash
# Update system and install dependencies
sudo apt update -y
sudo apt install openjdk-17-jre -y
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo chmod 644 /usr/share/keyrings/jenkins-keyring.asc
sudo apt-get install -y jenkins
cat /var/lib/jenkins/secrets/initialAdminPassword
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
sudo systemctl enable jenkins
sudo ufw allow 8080
sudo ufw allow OpenSSH
sudo ufw allow 22/tcp
sudo ufw enable
sudo ufw allow 443/tcp
sudo ufw allow 80/tcp
sudo ufw allow 8080/tcp
sudo systemctl start jenkins
sudo systemctl status jenkins
echo "Jenkins installation complete. Access Jenkins at http://<VM-Public-IP>:8080"
sudo ufw enable
