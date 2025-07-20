# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# CloudTrail Outputs
output "cloudtrail_bucket_arn" {
  description = "ARN of the CloudTrail S3 bucket"
  value       = module.cloudtrail.bucket_arn
}

output "cloudtrail_arn" {
  description = "ARN of the CloudTrail"
  value       = module.cloudtrail.cloudtrail_arn
}

output "cloudtrail_kms_key_arn" {
  description = "ARN of the KMS key used for CloudTrail encryption (if enabled)"
  value       = module.cloudtrail.kms_key_arn
}

# AWS Config Outputs
output "config_rule_arns" {
  description = "Map of Config rule names to ARNs"
  value       = module.config.rule_arns
}

output "config_recorder_arn" {
  description = "ARN of the AWS Config recorder"
  value       = module.config.recorder_arn
}

# IAM Outputs
output "iam_role_arns" {
  description = "Map of IAM role names to ARNs"
  value       = module.iam.role_arns
}

output "iam_role_names" {
  description = "List of IAM role names"
  value       = module.iam.role_names
}

# GuardDuty Outputs
output "guardduty_detector_id" {
  description = "ID of the GuardDuty detector (null if disabled)"
  value       = module.guardduty.detector_id
}

output "guardduty_detector_arn" {
  description = "ARN of the GuardDuty detector (null if disabled)"
  value       = module.guardduty.detector_arn
}

# Budget Outputs
output "budget_id" {
  description = "ID of the budget (null if budget not created)"
  value       = module.budget.budget_id
}

output "budget_arn" {
  description = "ARN of the budget (null if budget not created)"
  value       = module.budget.budget_arn
}

# Optional Feature Outputs
output "security_hub_enabled" {
  description = "Whether Security Hub is enabled"
  value       = var.enable_security_hub
}

output "macie_enabled" {
  description = "Whether Macie is enabled"
  value       = var.enable_macie
}

output "s3_block_public_access_enabled" {
  description = "Whether S3 Block Public Access is enabled"
  value       = var.enable_s3_block_public_access
} 