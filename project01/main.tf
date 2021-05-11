# Create EC2 instance, deploy on a custom VPC and a custom subnet, assign it with a public IP address so we can ssh into it and also set up a webserver.

provider "aws" {
  region     = "ap-southeast-2"
  access_key = "AKIA2D7PFXETR7RIXK73"
  secret_key = "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"
}

# 1. Create VPC
resource "aws_vpc" "dev-vpc-01" {
  cidr_block = "172.22.0.0/16"

  tags = {
    Name = "dev"
  }
}

# 2. Create Internet Gateway
resource "aws_internet_gateway" "dev-gw-01" {
  vpc_id = aws_vpc.dev-vpc-01.id

  tags = {
    Name = "dev"
  }
}

# 3. Create Custom Route Table
resource "aws_route_table" "dev-rtb-01" {
  vpc_id = aws_vpc.dev-vpc-01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-gw-01.id
  }

  tags = {
    Name = "dev"
  }
}

# 4. Create a Subnet
resource "aws_subnet" "dev-subnet-01" {
  vpc_id            = aws_vpc.dev-vpc-01.id
  cidr_block        = "172.22.0.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "dev"
  }
}

# 5. Associate subnet with Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.dev-subnet-01.id
  route_table_id = aws_route_table.dev-rtb-01.id
}

# 6. Create Security Group to allow port 22, 80, 443
resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.dev-vpc-01.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web_traffic"
  }
}

# 7. Create a network interface with an IP in the subnet that was created in step 4
resource "aws_network_interface" "webserver-nic" {
  subnet_id       = aws_subnet.dev-subnet-01.id
  private_ips     = ["172.22.0.10"]
  security_groups = [aws_security_group.allow_web.id]
}

# 8. Assign a elastic IP to the network interface created in step 7
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.webserver-nic.id
  associate_with_private_ip = "172.22.0.10"
  depends_on                = [aws_internet_gateway.dev-gw-01]
}

# 9. Create Ubuntu server and install/enable apache2
resource "aws_instance" "dev-web-01" {
	ami = "ami-0567f647e75c7bc05"
    instance_type = "t2.micro"
    availability_zone = "ap-southeast-2a"
    key_name = "dev-kp-01"

    network_interface {
      device_index = 0
      network_interface_id = aws_network_interface.webserver-nic.id
    }
    user_data = <<EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                EOF
    tags = {
      Name = "dev"
  }
}

   

