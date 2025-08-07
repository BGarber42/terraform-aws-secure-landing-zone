# Account ID is now automatically detected from AWS credentials
# variable "account_id" {
#   description = "AWS Account ID"
#   type        = string
# }

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cloudtrail_bucket_name" {
  description = "Name of the S3 bucket for CloudTrail logs"
  type        = string
  default     = "my-org-cloudtrail-logs-basic"
}

variable "guardduty_kms_key_arn" {
  description = "KMS key ARN for GuardDuty publishing destination"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "development"
    Owner       = "platform-team"
    Project     = "landing-zone"
  }
} 