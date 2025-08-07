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

# VPC Module
module "vpc" {
  source = "./vpc"

  account_id           = var.account_id
  region               = var.region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = var.tags
}

# CloudTrail Module
module "cloudtrail" {
  source = "./cloudtrail"

  account_id             = var.account_id
  region                 = var.region
  cloudtrail_bucket_name = var.cloudtrail_bucket_name
  cloudtrail_enable_kms  = var.cloudtrail_enable_kms
  tags                   = var.tags
}

# AWS Config Module
module "config" {
  source = "./config"

  account_id         = var.account_id
  region             = var.region
  config_bucket_name = var.cloudtrail_bucket_name
  config_rules       = var.config_rules
  tags               = var.tags
}

# IAM Module
module "iam" {
  source = "./iam"

  account_id = var.account_id
  region     = var.region
  iam_roles  = var.iam_roles
  tags       = var.tags
}

# GuardDuty Module
module "guardduty" {
  source = "./guardduty"

  account_id                     = var.account_id
  region                         = var.region
  enable_guardduty               = var.enable_guardduty
  guardduty_findings_bucket_name = var.guardduty_findings_bucket_name
  guardduty_kms_key_arn          = var.guardduty_kms_key_arn
  tags                           = var.tags
}

# Budget Module
module "budget" {
  source = "./budget"

  account_id               = var.account_id
  region                   = var.region
  enable_budget_alerts     = var.enable_budget_alerts
  enable_budget_actions    = var.enable_budget_actions
  budget_limit_usd         = var.budget_limit_usd
  budget_alert_subscribers = var.budget_alert_subscribers
  tags                     = var.tags
}

# Security Hub Module
module "security_hub" {
  source = "./security_hub"

  account_id            = var.account_id
  region                = var.region
  enable_security_hub   = var.enable_security_hub
  enable_cis_standard   = var.enable_cis_standard
  enable_pci_standard   = var.enable_pci_standard
  enable_action_targets = var.enable_action_targets
  tags                  = var.tags
}

# Macie Module
module "macie" {
  source = "./macie"

  account_id                   = var.account_id
  region                       = var.region
  enable_macie                 = var.enable_macie
  finding_publishing_frequency = var.macie_finding_publishing_frequency
  enable_s3_classification     = var.enable_macie_s3_classification
  s3_buckets_to_scan           = var.macie_s3_buckets_to_scan
  excluded_file_extensions     = var.macie_excluded_file_extensions
  custom_data_identifiers      = var.macie_custom_data_identifiers
  tags                         = var.tags
} 