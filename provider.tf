terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # Recommended: Use S3 for remote state
  backend "s3" {
    bucket = "terraform-s3state-bucket"
    key    = "jenkins/terraform.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = var.aws_region
}

