provider "aws" {
	region = var.region
}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"

  name = "mgmt-vpc"
  cidr = "172.0.0.0/16"
  
  azs             = var.vpc_azs
  private_subnets = ["172.0.1.0/24", "172.0.2.0/24", "172.0.3.0/24"]
  public_subnets  = ["172.0.10.0/24", "172.0.20.0/24", "172.0.30.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "overridden-name-public"
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "mgmt-vpc"
  
}
}
