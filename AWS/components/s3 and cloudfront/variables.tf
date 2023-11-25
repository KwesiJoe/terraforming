variable "buckets" {
  type = list(string)
  description = "names of buckets to create"
}

variable "region" {
  type = string
  description = "aws region"
}