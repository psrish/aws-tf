variable "region" {
   default =   "ap-southeast-2"
}

variable "vpc_azs" {
  description = "List of Subnet AZs"
  default     = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
}
