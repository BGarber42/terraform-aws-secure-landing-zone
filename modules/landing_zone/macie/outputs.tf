output "macie_enabled" {
  description = "Whether Macie is enabled"
  value       = var.enable_macie
}

output "classification_job_enabled" {
  description = "Whether S3 classification job is enabled"
  value       = var.enable_macie && var.enable_s3_classification
}

output "custom_identifiers_count" {
  description = "Number of custom data identifiers created"
  value       = length(var.custom_data_identifiers)
}

output "buckets_to_scan_count" {
  description = "Number of S3 buckets configured for scanning"
  value       = length(var.s3_buckets_to_scan)
} 