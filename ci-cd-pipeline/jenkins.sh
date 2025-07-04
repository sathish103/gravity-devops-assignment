#!/bin/bash

sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
# Add required dependencies for the jenkins package
sudo yum install -y fontconfig java-17-amazon-corretto
sudo yum install git jenkins -y
sudo systemctl daemon-reload


sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
sudo sleep 10
sudo cat /var/lib/jenkins/secrets/initialAdminPassword 