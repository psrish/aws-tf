provider "aws" {
	region = "ap-southeast-2"
}
resource "aws_instance" "myserver" {
	ami = "ami-09624659bc7805447"
    instance_type = "t2.micro"
}