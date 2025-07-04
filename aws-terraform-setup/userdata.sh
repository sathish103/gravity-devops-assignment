#!/bin/bash
yum update -y
yum install -y nginx
systemctl enable nginx
systemctl start nginx
echo "<h1>Running Gravity Application on Nginx</h1>" > /usr/share/nginx/html/index.html
