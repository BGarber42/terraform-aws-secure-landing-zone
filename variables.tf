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

# VPC Variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

# CloudTrail Variables
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

# AWS Config Variables
variable "config_rules" {
  description = "Map of AWS Config rule names to rule configurations"
  type        = map(string)
  default = {
    "s3-bucket-public-read-prohibited"  = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
    "s3-bucket-public-write-prohibited" = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
    "s3-bucket-ssl-requests-only"       = "S3_BUCKET_SSL_REQUESTS_ONLY"
    "s3-bucket-versioning-enabled"      = "S3_BUCKET_VERSIONING_ENABLED"
    "s3-bucket-logging-enabled"         = "S3_BUCKET_LOGGING_ENABLED"
  }
}

# IAM Variables
variable "iam_roles" {
  description = "List of IAM role configurations"
  type = list(object({
    name                = string
    description         = string
    policy_arn          = optional(string)
    inline_policy       = optional(string)
    permission_boundary = optional(string)
  }))
  default = [
    {
      name        = "ReadOnlyAdmin"
      description = "Read-only administrator role"
      policy_arn  = "arn:aws:iam::aws:policy/ReadOnlyAccess"
    },
    {
      name        = "PowerUserRestrictedIAM"
      description = "Power user role with restricted IAM access"
      policy_arn  = "arn:aws:iam::aws:policy/PowerUserAccess"
    }
  ]
}

# GuardDuty Variables
variable "enable_guardduty" {
  description = "Enable GuardDuty threat detection"
  type        = bool
  default     = true
}

variable "guardduty_findings_bucket_name" {
  description = "Name of the S3 bucket for GuardDuty findings"
  type        = string
  default     = "guardduty-findings"
}

variable "guardduty_kms_key_arn" {
  description = "KMS key ARN for GuardDuty publishing destination"
  type        = string
  default     = ""
}

# Budget Variables
variable "enable_budget_alerts" {
  description = "Enable budget alerts and notifications"
  type        = bool
  default     = true
}

variable "enable_budget_actions" {
  description = "Enable budget actions for automated responses"
  type        = bool
  default     = false
}

variable "budget_limit_usd" {
  description = "Monthly budget limit in USD"
  type        = number
  default     = 500
}

variable "budget_alert_subscribers" {
  description = "List of email addresses for budget alerts"
  type        = list(string)
  default     = []
}

# Security Hub Variables
variable "enable_security_hub" {
  description = "Enable AWS Security Hub"
  type        = bool
  default     = false
}

variable "enable_cis_standard" {
  description = "Enable CIS AWS Foundations Benchmark standard"
  type        = bool
  default     = true
}

variable "enable_pci_standard" {
  description = "Enable PCI DSS standard"
  type        = bool
  default     = false
}

variable "enable_action_targets" {
  description = "Enable Security Hub action targets"
  type        = bool
  default     = true
}

# Macie Variables
variable "enable_macie" {
  description = "Enable Amazon Macie"
  type        = bool
  default     = false
}

variable "macie_finding_publishing_frequency" {
  description = "Frequency for publishing Macie findings"
  type        = string
  default     = "FIFTEEN_MINUTES"

  validation {
    condition     = contains(["FIFTEEN_MINUTES", "ONE_HOUR", "SIX_HOURS"], var.macie_finding_publishing_frequency)
    error_message = "Finding publishing frequency must be one of: FIFTEEN_MINUTES, ONE_HOUR, SIX_HOURS."
  }
}

variable "enable_macie_s3_classification" {
  description = "Enable S3 classification job for Macie"
  type        = bool
  default     = true
}

variable "macie_s3_buckets_to_scan" {
  description = "List of S3 bucket names to scan with Macie"
  type        = list(string)
  default     = []
}

variable "macie_excluded_file_extensions" {
  description = "File extensions to exclude from Macie scanning"
  type        = list(string)
  default     = ["jpg", "jpeg", "png", "gif", "mp4", "avi", "mov"]
}

variable "macie_custom_data_identifiers" {
  description = "Map of custom data identifiers for Macie"
  type = map(object({
    description  = string
    regex        = string
    keywords     = list(string)
    ignore_words = list(string)
  }))
  default = {}
}

# Optional Feature Toggles
variable "enable_s3_block_public_access" {
  description = "Enable S3 Block Public Access"
  type        = bool
  default     = false
} 