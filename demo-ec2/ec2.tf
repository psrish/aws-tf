data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "aws-bastion-sg"
  description = "Security group for example usage with EC2 instance"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}


module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.17.0"
  
  instance_count = 1

  name          = "aws-bastion01"
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  cpu_credits   = "unlimited"
  subnet_id     = tolist(module.vpc.private_subnets)[0]
  #  private_ip = "172.31.32.10"
  vpc_security_group_ids      = [module.security_group.this_security_group_id]
  associate_public_ip_address = true
  # insert the 10 required variables here

}
