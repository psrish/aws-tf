provider "aws" {
	region = var.region
}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"

  name = "bst-staging-vpc-02"
  cidr = "172.0.0.0/16"
  
  azs             = var.vpc_azs
  private_subnets = ["172.17.0.0/19", "172.17.32.0/19", "172.17.64.0/19"]
  public_subnets  = ["172.37.0.0/19", "172.37.32.0/19", "172.37.64.0/19"]

  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "bst-staging-pub-vpc-02"
  }

  tags = {
    Owner       = "Terraform"
    Environment = "staging"
  }

  vpc_tags = {
    Name = "bst-staging-vpc-02"
  
}
}
