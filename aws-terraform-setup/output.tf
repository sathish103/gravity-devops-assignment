#output of ec2-instance Public IP

output "ec2_instance_public_ip" {
  value = aws_instance.gravity-ec2-instance.public_ip
}

output "key_pair_name" {
  value = aws_key_pair.gravity-key-pair.key_name
  sensitive = true
}