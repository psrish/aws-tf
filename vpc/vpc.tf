provider "aws" {
	region = var.region
}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"

  name = "mgmt-vpc-01"
  cidr = "172.18.0.0/16"
  
  azs             = var.vpc_azs
  private_subnets = ["172.18.0.0/24", "172.18.32.0/24", "172.18.64.0/24"]
  public_subnets  = ["172.18.96.0/24", "172.18.128.0/24", "172.18.160.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "mgmt-pub-vpc-01"
  }

  tags = {
    Owner       = "Terraform"
    Environment = "mgmt"
  }

  vpc_tags = {
    Name = "mgmt-vpc-01"
  
}
}

resource "aws_instance" "myserver" {
  ami           = "ami-09624659bc7805447"
  instance_type = "t2.micro"
  subnet_id =  module.vpc.private_subnets[0]
}
