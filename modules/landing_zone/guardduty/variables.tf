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

variable "enable_guardduty" {
  description = "Enable GuardDuty detector"
  type        = bool
  default     = true
}

variable "guardduty_findings_bucket_name" {
  description = "Name of the S3 bucket for GuardDuty findings"
  type        = string
}

variable "guardduty_kms_key_arn" {
  description = "KMS key ARN for GuardDuty publishing destination"
  type        = string
  default     = ""
} 