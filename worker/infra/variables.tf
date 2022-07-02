# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "stack-name" {
  type    = string
  default = "dotnet-terraform-personal-project-worker"
}