terraform {
  required_version = ">= 1.12.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
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

  account_id             = var.account_id
  region                 = var.region
  cloudtrail_bucket_name = var.cloudtrail_bucket_name
  tags                   = var.tags
}

# Outputs from the landing zone module
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.landing_zone.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.landing_zone.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.landing_zone.private_subnet_ids
}

output "cloudtrail_bucket_arn" {
  description = "ARN of the CloudTrail S3 bucket"
  value       = module.landing_zone.cloudtrail_bucket_arn
} 