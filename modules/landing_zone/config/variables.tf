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

variable "config_bucket_name" {
  description = "Name of the S3 bucket for AWS Config logs"
  type        = string
}

variable "config_rules" {
  description = "Map of AWS Config rule names to rule configurations"
  type        = map(string)
  default = {
    "s3-bucket-public-read-prohibited" = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
    "s3-bucket-public-write-prohibited" = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
    "s3-bucket-ssl-requests-only" = "S3_BUCKET_SSL_REQUESTS_ONLY"
    "s3-bucket-versioning-enabled" = "S3_BUCKET_VERSIONING_ENABLED"
    "s3-bucket-logging-enabled" = "S3_BUCKET_LOGGING_ENABLED"
  }
} 