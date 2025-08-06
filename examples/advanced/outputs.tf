# VPC Outputs
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

# Security Outputs
output "cloudtrail_bucket_arn" {
  description = "ARN of the CloudTrail S3 bucket"
  value       = module.landing_zone.cloudtrail_bucket_arn
}

output "guardduty_detector_id" {
  description = "ID of the GuardDuty detector"
  value       = module.landing_zone.guardduty_detector_id
}

output "security_hub_enabled" {
  description = "Whether Security Hub is enabled"
  value       = module.landing_zone.security_hub_enabled
}

output "cis_standard_enabled" {
  description = "Whether CIS AWS Foundations Benchmark standard is enabled"
  value       = module.landing_zone.cis_standard_enabled
}

output "pci_standard_enabled" {
  description = "Whether PCI DSS standard is enabled"
  value       = module.landing_zone.pci_standard_enabled
}

output "macie_enabled" {
  description = "Whether Macie is enabled"
  value       = module.landing_zone.macie_enabled
}

output "macie_classification_job_enabled" {
  description = "Whether S3 classification job is enabled"
  value       = module.landing_zone.macie_classification_job_enabled
}

output "macie_custom_identifiers_count" {
  description = "Number of custom data identifiers created"
  value       = module.landing_zone.macie_custom_identifiers_count
}

# Budget Outputs
output "budget_id" {
  description = "ID of the cost budget"
  value       = module.landing_zone.budget_id
}

output "budget_sns_topic_arn" {
  description = "ARN of the SNS topic for budget alerts"
  value       = module.landing_zone.budget_sns_topic_arn
}

# IAM Outputs
output "iam_role_arns" {
  description = "Map of IAM role names to ARNs"
  value       = module.landing_zone.iam_role_arns
}

output "iam_role_names" {
  description = "List of IAM role names"
  value       = module.landing_zone.iam_role_names
} 