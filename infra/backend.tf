terraform {
  backend "s3" {
    bucket         = "terraform-state-buckt"
    key            = "backend/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-lock"
    encrypt        = true
  }
  required_version = ">= 1.6.0"
  required_providers {
    aws = { 
        source = "hashicorp/aws"
        version = "~> 5.0" 
        }
    random = { 
        source = "hashicorp/random" 
        version = "~> 3.6" 
        }
  }
}

provider "aws" {
  region = var.region
}
