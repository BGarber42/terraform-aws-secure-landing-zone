terraform {
  required_version = ">= 1.12.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Data sources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Landing Zone Module with Advanced Features
module "landing_zone" {
  source = "../../modules/landing_zone"

  # Basic Configuration
  account_id = data.aws_caller_identity.current.account_id
  region     = var.region

  # VPC Configuration
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  # CloudTrail Configuration
  cloudtrail_bucket_name = var.cloudtrail_bucket_name
  cloudtrail_enable_kms  = true

  # AWS Config Configuration
  config_rules = {
    "s3-bucket-public-read-prohibited"  = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
    "s3-bucket-public-write-prohibited" = "S3_BUCKET_PUBLIC_WRITE_PROHIBITED"
    "s3-bucket-ssl-requests-only"       = "S3_BUCKET_SSL_REQUESTS_ONLY"
    "s3-bucket-versioning-enabled"      = "S3_BUCKET_VERSIONING_ENABLED"
    "s3-bucket-logging-enabled"         = "S3_BUCKET_LOGGING_ENABLED"
    "iam-password-policy"               = "IAM_PASSWORD_POLICY"
    "iam-user-mfa-enabled"              = "IAM_USER_MFA_ENABLED"
    "rds-instance-public-access-check"  = "RDS_INSTANCE_PUBLIC_ACCESS_CHECK"
    "rds-snapshots-public-prohibited"   = "RDS_SNAPSHOTS_PUBLIC_PROHIBITED"
  }

  # IAM Configuration
  iam_roles = [
    {
      name        = "ReadOnlyAdmin"
      description = "Read-only administrator role"
      policy_arn  = "arn:aws:iam::aws:policy/ReadOnlyAccess"
    },
    {
      name        = "PowerUserRestrictedIAM"
      description = "Power user role with restricted IAM access"
      policy_arn  = "arn:aws:iam::aws:policy/PowerUserAccess"
    },
    {
      name        = "SecurityAuditor"
      description = "Security auditor role"
      policy_arn  = "arn:aws:iam::aws:policy/SecurityAudit"
    }
  ]

  # GuardDuty Configuration
  enable_guardduty               = true
  guardduty_findings_bucket_name = var.guardduty_findings_bucket_name

  # Budget Configuration
  enable_budget_alerts     = true
  enable_budget_actions    = false
  budget_limit_usd         = var.budget_limit_usd
  budget_alert_subscribers = var.budget_alert_subscribers

  # Security Hub Configuration
  enable_security_hub   = true
  enable_cis_standard   = true
  enable_pci_standard   = var.enable_pci_standard
  enable_action_targets = true

  # Macie Configuration
  enable_macie                       = true
  macie_finding_publishing_frequency = "FIFTEEN_MINUTES"
  enable_macie_s3_classification     = true
  s3_buckets_to_scan                 = var.macie_s3_buckets_to_scan
  excluded_file_extensions           = ["jpg", "jpeg", "png", "gif", "mp4", "avi", "mov", "pdf"]
  custom_data_identifiers = {
    "credit_card_pattern" = {
      description  = "Credit card number pattern"
      regex        = "\\b\\d{4}[- ]?\\d{4}[- ]?\\d{4}[- ]?\\d{4}\\b"
      keywords     = ["credit", "card", "payment"]
      ignore_words = ["test", "example", "sample"]
    },
    "ssn_pattern" = {
      description  = "Social Security Number pattern"
      regex        = "\\b\\d{3}-\\d{2}-\\d{4}\\b"
      keywords     = ["ssn", "social", "security"]
      ignore_words = ["test", "example"]
    }
  }

  # Tags
  tags = merge(var.tags, {
    Environment = "advanced"
    Project     = "secure-landing-zone"
    Owner       = "platform-team"
  })
} 