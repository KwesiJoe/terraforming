variable "buckets" {
  type = list(string)
  description = "names of buckets to create"
}

variable "region" {
  type = string
  description = "aws region"
}

variable "origin_access_control_name" {
  type = string
  description = "origin access control name"
}
