region = "us-west-1"
project = "tuulbox"
vpc_cidr = "10.0.0.0/16"

subnets = {
  "subnet1" = {
	cidr_block = "10.0.0.0/24"
	availability_zone = "us-west-1c"
  } //modify and add more to meet your needs.
  "subnet2" = {
	cidr_block = "10.0.1.0/24"
	availability_zone = "us-west-1c"
  } //modify and add more to meet your needs.
  "subnet3" = {
	cidr_block = "10.0.2.0/24"
	availability_zone = "us-west-1a"
  } //modify and add more to meet your needs.
  "subnet4" = {
	cidr_block = "10.0.3.0/24"
	availability_zone = "us-west-1a"
  } //modify and add more to meet your needs.
}
