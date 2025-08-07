variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_count" {
  description = "Number of public subnets to create (CIDRs will be calculated automatically)"
  type        = number
  default     = 2
}

variable "private_subnet_count" {
  description = "Number of private subnets to create (CIDRs will be calculated automatically)"
  type        = number
  default     = 2
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (optional, will be calculated if not provided)"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (optional, will be calculated if not provided)"
  type        = list(string)
  default     = []
}

variable "cloudtrail_bucket_name" {
  description = "Name of the S3 bucket for CloudTrail logs"
  type        = string
  default     = "my-org-cloudtrail-logs-advanced"
}

variable "guardduty_findings_bucket_name" {
  description = "Name of the S3 bucket for GuardDuty findings"
  type        = string
  default     = "my-org-guardduty-findings-advanced"
}



variable "budget_limit_usd" {
  description = "Monthly budget limit in USD"
  type        = number
  default     = 1000
}

variable "budget_alert_subscribers" {
  description = "List of email addresses for budget alerts"
  type        = list(string)
  default     = ["admin@example.com", "finance@example.com"]
}

variable "enable_pci_standard" {
  description = "Enable PCI DSS standard in Security Hub"
  type        = bool
  default     = false
}

variable "macie_s3_buckets_to_scan" {
  description = "List of S3 bucket names to scan with Macie"
  type        = list(string)
  default     = ["my-data-bucket", "my-backup-bucket"]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "advanced"
    Project     = "secure-landing-zone"
    Owner       = "platform-team"
    CostCenter  = "security"
  }
} 