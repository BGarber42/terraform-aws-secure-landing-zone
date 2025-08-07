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

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = module.vpc.nat_gateway_id
}

# CloudTrail Outputs
output "cloudtrail_bucket_arn" {
  description = "ARN of the CloudTrail S3 bucket"
  value       = module.cloudtrail.bucket_arn
}

output "cloudtrail_bucket_name" {
  description = "Name of the CloudTrail S3 bucket"
  value       = module.cloudtrail.bucket_name
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
  value       = module.config.recorder_name
}

output "config_recorder_name" {
  description = "Name of the AWS Config recorder"
  value       = module.config.recorder_name
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
  description = "ID of the GuardDuty detector"
  value       = module.guardduty.detector_id
}

output "guardduty_detector_arn" {
  description = "ARN of the GuardDuty detector"
  value       = module.guardduty.detector_arn
}

output "guardduty_findings_bucket_arn" {
  description = "ARN of the GuardDuty findings S3 bucket"
  value       = module.guardduty.findings_bucket_arn
}

# Budget Outputs
output "budget_id" {
  description = "ID of the cost budget"
  value       = module.budget.budget_id
}

output "budget_arn" {
  description = "ARN of the cost budget"
  value       = module.budget.budget_arn
}

output "budget_sns_topic_arn" {
  description = "ARN of the SNS topic for budget alerts"
  value       = module.budget.sns_topic_arn
}

# Security Hub Outputs
output "security_hub_enabled" {
  description = "Whether Security Hub is enabled"
  value       = module.security_hub.security_hub_enabled
}

output "cis_standard_enabled" {
  description = "Whether CIS AWS Foundations Benchmark standard is enabled"
  value       = module.security_hub.cis_standard_enabled
}

output "pci_standard_enabled" {
  description = "Whether PCI DSS standard is enabled"
  value       = module.security_hub.pci_standard_enabled
}

output "security_hub_action_targets_enabled" {
  description = "Whether Security Hub action targets are enabled"
  value       = module.security_hub.action_targets_enabled
}

output "security_hub_insights_created" {
  description = "Number of Security Hub insights created"
  value       = module.security_hub.insights_created
}

# Macie Outputs
output "macie_enabled" {
  description = "Whether Macie is enabled"
  value       = module.macie.macie_enabled
}

output "macie_classification_job_enabled" {
  description = "Whether S3 classification job is enabled"
  value       = module.macie.classification_job_enabled
}

output "macie_custom_identifiers_count" {
  description = "Number of custom data identifiers created"
  value       = module.macie.custom_identifiers_count
}

output "macie_buckets_to_scan_count" {
  description = "Number of S3 buckets configured for scanning"
  value       = module.macie.buckets_to_scan_count
}

# Optional Feature Outputs
output "s3_block_public_access_enabled" {
  description = "Whether S3 Block Public Access is enabled"
  value       = var.enable_s3_block_public_access
} 