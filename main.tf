provider "aws" {
	region = "ap-southeast-2"
}

resource "aws_instance" "myserver" {
	ami = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
}