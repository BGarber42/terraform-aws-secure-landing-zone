variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "prod"
    Owner       = "platform"
  }
}

variable "prevent_destroy" {
  description = "Whether to prevent destruction of critical resources (S3 buckets, KMS keys). Set to false for testing environments."
  type        = bool
  default     = true
}

variable "cloudtrail_bucket_name" {
  description = "Name of the S3 bucket for CloudTrail logs"
  type        = string
  default     = "cloudtrail-logs"
}

variable "cloudtrail_enable_kms" {
  description = "Enable KMS encryption for CloudTrail"
  type        = bool
  default     = true
}

variable "s3_encryption_key_arn" {
  description = "ARN of the KMS key for S3 encryption"
  type        = string
} 