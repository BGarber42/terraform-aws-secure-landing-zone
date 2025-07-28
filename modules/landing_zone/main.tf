terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# VPC Module
module "vpc" {
  source = "./vpc"

  account_id            = var.account_id
  region                = var.region
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  tags                  = var.tags
}

# CloudTrail Module
module "cloudtrail" {
  source = "./cloudtrail"

  account_id              = var.account_id
  region                  = var.region
  cloudtrail_bucket_name  = var.cloudtrail_bucket_name
  cloudtrail_enable_kms   = var.cloudtrail_enable_kms
  tags                    = var.tags
}

# AWS Config Module
module "config" {
  source = "./config"

  account_id        = var.account_id
  region            = var.region
  config_bucket_name = var.cloudtrail_bucket_name
  config_rules      = var.config_rules
  tags              = var.tags
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

  account_id         = var.account_id
  region             = var.region
  enable_guardduty   = var.enable_guardduty
  tags               = var.tags
}

# Budget Module
module "budget" {
  source = "./budget"

  account_id                  = var.account_id
  region                      = var.region
  budget_limit_usd            = var.budget_limit_usd
  budget_alert_subscribers    = var.budget_alert_subscribers
  tags                        = var.tags
} 