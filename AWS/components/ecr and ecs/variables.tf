variable "repositories" {
  type = list(string)
  description = "names of ecr repositories to create"
}

variable "region" {
  type = string
  description = "aws region"
}

variable "project" {
  type = string
  description = "project name to be used to tag resources"
}

variable "clusters" {
  type = list(string)
  description = "names of ecs clusters to create"
}