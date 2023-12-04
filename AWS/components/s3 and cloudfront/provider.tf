terraform {
  backend "local" {
    
  }

  # backend "s3" {
  #   bucket = "mybucket"
  #   key    = "path/to/my/key"
  #   region = "aws_region"
  # }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.26.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      project = var.project
    }
  }
}