terraform {
  backend "s3" {
    bucket = "terraform-9b9eff0a-1fcb-46f1-b970-267d3760c8f3"
    key    = "dotnet-terraform-personal-project-worker"
    region = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt = true
  }
  
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.21.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  profile = "default"
  region  = var.aws_region

  default_tags {
    tags = {
      environment = var.environment
      stack-name = var.stack-name
    }
  }
}

