#Variables

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"

}

variable "aws_vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

}

variable "public_subnet_cidr" {
  description = "value for the Pub subnet CIDR"
  type        = string
  default     = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "value for the Private subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "Instance type for ec2 instance"
  type        = string
  default     = "t2.micro"
}





