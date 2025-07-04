# VPC, Subnets, Route tables, Igw, Nat Gateway, Security group, EC2 Instance

data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.7.20250623.1-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_vpc" "gravity-vpc" {
  cidr_block           = var.aws_vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "gravity-vpc"
  }

}

resource "aws_internet_gateway" "gravity-igw" {
  vpc_id = aws_vpc.gravity-vpc.id

  tags = {
    name = "gravity-igw"
  }
}

resource "aws_subnet" "gravity-public-subnet" {
  vpc_id                  = aws_vpc.gravity-vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "gravity-public-subnet"
  }
}

resource "aws_subnet" "gravity-private-subnet" {
  vpc_id            = aws_vpc.gravity-vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "ap-south-1a"

  tags = {
    Name = "gravity-private-subnet"
  }
}

resource "aws_route_table" "gravity-public-rt" {
  vpc_id = aws_vpc.gravity-vpc.id

  tags = {
    Name = "gravity-public-rt"
  }
}

resource "aws_route_table" "gravity-private-rt" {
  vpc_id = aws_vpc.gravity-vpc.id

  tags = {
    Name = "gravity-private-rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.gravity-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gravity-igw.id
}

resource "aws_route_table_association" "Public-rt-association" {
  subnet_id      = aws_subnet.gravity-public-subnet.id
  route_table_id = aws_route_table.gravity-public-rt.id
}

resource "aws_eip" "gravity-nat-eip" {

  tags = {
    Name = "gravity-nat-eip"
  }
}


resource "aws_nat_gateway" "gravity-nat-gateway" {
  allocation_id = aws_eip.gravity-nat-eip.id
  subnet_id     = aws_subnet.gravity-public-subnet.id

  tags = {
    Name = "gravity-nat-gateway"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.gravity-private-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gravity-nat-gateway.id
}

resource "aws_route_table_association" "private-rt-association" {
  subnet_id      = aws_subnet.gravity-private-subnet.id
  route_table_id = aws_route_table.gravity-private-rt.id
}


resource "aws_security_group" "web-sg" {
  vpc_id      = aws_vpc.gravity-vpc.id
  description = "Allow SSH, HTTP and HTTPS traffic"

  tags = {
    Name = "web-sg"
  }
}

resource "aws_security_group_rule" "Allow-SSH" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["103.215.164.90/32"] # Replace with your IP address
  security_group_id = aws_security_group.web-sg.id
}

resource "aws_security_group_rule" "Allow-HTTP" { 
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web-sg.id
}

resource "aws_security_group_rule" "Allow-HTTPS" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web-sg.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web-sg.id
}


resource "tls_private_key" "gravity-key" {
    algorithm = "RSA"
    rsa_bits = 4096

}

resource "aws_key_pair" "gravity-key-pair" {
    key_name = "gravity-key"
    public_key = tls_private_key.gravity-key.public_key_openssh

    tags = {
        Name = "gravity-key"
    }

}

resource  "local_file" "private_key_file" {
    content = tls_private_key.gravity-key.private_key_pem
    filename = "${path.module}/gravity-key.pem"
}
    



resource "aws_instance" "gravity-ec2-instance" {
  ami             = data.aws_ami.amazon-linux.id
  instance_type   = var.instance_type
  subnet_id       = aws_subnet.gravity-public-subnet.id
  key_name        = aws_key_pair.gravity-key-pair.key_name
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data       = file("userdata.sh")

  tags = {
    Name = "gravity-ec2-instance"
  }
}







