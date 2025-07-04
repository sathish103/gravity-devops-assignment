# DevOps Assignment – AWS Terraform + Jenkins + CloudWatch

## Project Overview
Provision AWS infra using Terraform, deploy web app using Jenkins CI/CD, monitor with CloudWatch.

## Tools Used
- AWS (EC2, VPC, SNS, CloudWatch)
- Terraform
- Jenkins
- GitHub
- Nginx Web Server
- stress (for CPU testing)

## Infrastructure Setup (Terraform)
- VPC with public and private subnets
- EC2 instance in public subnet with NGINX installed
- Firewall rules for HTTP/HTTPS access

## CI/CD Pipeline (Jenkins)
- Jenkins pulls from GitHub repo
- Runs basic tests before deploy
- Deploys to EC2 via SSH

## Monitoring & Alerting
- CloudWatch CPU Utilization
- Alarm triggers if CPU > 80% (2 intervals)
- SNS sends email to: "example@gmail.com"

## Test the Alert
```bash
# On EC2 instance
sudo yum install -y stress
stress --cpu 1 --timeout 600
