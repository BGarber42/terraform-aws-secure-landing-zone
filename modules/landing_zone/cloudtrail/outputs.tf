output "bucket_arn" {
  description = "ARN of the CloudTrail S3 bucket"
  value       = aws_s3_bucket.cloudtrail.arn
}

output "bucket_name" {
  description = "Name of the CloudTrail S3 bucket"
  value       = aws_s3_bucket.cloudtrail.bucket
}

output "cloudtrail_arn" {
  description = "ARN of the CloudTrail"
  value       = aws_cloudtrail.main.arn
}

output "cloudtrail_name" {
  description = "Name of the CloudTrail"
  value       = aws_cloudtrail.main.name
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for CloudTrail encryption (if enabled)"
  value       = var.cloudtrail_enable_kms ? aws_kms_key.cloudtrail[0].arn : null
}

output "kms_key_id" {
  description = "ID of the KMS key used for CloudTrail encryption (if enabled)"
  value       = var.cloudtrail_enable_kms ? aws_kms_key.cloudtrail[0].id : null
} 