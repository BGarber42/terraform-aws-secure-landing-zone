output "bucket_arn" {
  description = "ARN of the CloudTrail S3 bucket"
  value       = local.cloudtrail_bucket.arn
}

output "bucket_name" {
  description = "Name of the CloudTrail S3 bucket"
  value       = local.cloudtrail_bucket.bucket
}

output "cloudtrail_arn" {
  description = "ARN of the CloudTrail"
  value       = aws_cloudtrail.main.arn
}

output "cloudtrail_name" {
  description = "Name of the CloudTrail"
  value       = aws_cloudtrail.main.name
}

 