variable "buckets" {
  type        = list(string)
  description = "names of buckets to create"
}

variable "region" {
  type        = string
  description = "aws region"
}

variable "origin_access_control_name" {
  type        = string
  description = "origin access control name"
}

variable "project" {
  type        = string
  description = "project name to be used to tag resources"
}

variable "origins" {
  type = map(object({
    bucket  = string
    aliases = list(string)
    comment = string
  }))
}

variable "acm_certificate_arn" {
  type = string
}
