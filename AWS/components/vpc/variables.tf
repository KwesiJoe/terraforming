variable "region" {
  type = string
  description = "aws region"
}

variable "project" {
  type = string
  description = "project name to be used to tag resources"
}

variable "vpc_cidr" {
  description = "cidrs for VPCs to create"
  type = string
}

variable "subnets" {
  description = "subnets for the vpc"
  type = map(object({
	cidr_block = string
	availability_zone = string
  }))
}
