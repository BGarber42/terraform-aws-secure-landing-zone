terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# This is a placeholder for the landing zone module
# It will be implemented in subsequent phases
module "landing_zone" {
  source = "../../modules/landing_zone"

  account_id              = var.account_id
  region                  = var.region
  cloudtrail_bucket_name  = var.cloudtrail_bucket_name
  tags                    = var.tags
}

# Outputs will be added as modules are implemented
output "vpc_id" {
  description = "The ID of the VPC"
  value       = "placeholder"
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = ["placeholder"]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = ["placeholder"]
}

output "cloudtrail_bucket_arn" {
  description = "ARN of the CloudTrail S3 bucket"
  value       = "placeholder"
} 