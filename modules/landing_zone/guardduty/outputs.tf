output "detector_id" {
  description = "ID of the GuardDuty detector"
  value       = var.enable_guardduty ? aws_guardduty_detector.main[0].id : null
}

output "detector_arn" {
  description = "ARN of the GuardDuty detector"
  value       = var.enable_guardduty ? aws_guardduty_detector.main[0].arn : null
}

output "findings_bucket_arn" {
  description = "ARN of the GuardDuty findings S3 bucket"
  value       = var.enable_guardduty ? aws_s3_bucket.guardduty_findings[0].arn : null
}

output "findings_bucket_name" {
  description = "Name of the GuardDuty findings S3 bucket"
  value       = var.enable_guardduty ? aws_s3_bucket.guardduty_findings[0].bucket : null
}

output "publishing_destination_arn" {
  description = "ARN of the GuardDuty publishing destination"
  value       = var.enable_guardduty ? aws_guardduty_publishing_destination.main[0].destination_arn : null
} 