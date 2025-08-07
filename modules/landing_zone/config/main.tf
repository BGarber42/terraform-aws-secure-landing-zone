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

# IAM Role for AWS Config
resource "aws_iam_role" "config" {
  name = "aws-config-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "aws-config-role"
  })
}

# IAM Role Policy for AWS Config
resource "aws_iam_role_policy" "config" {
  name = "aws-config-policy"
  role = aws_iam_role.config.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetBucketAcl",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.config_bucket_name}",
          "arn:aws:s3:::${var.config_bucket_name}/*"
        ]
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = "*"
      }
    ]
  })
}

# AWS Config Configuration Recorder
resource "aws_config_configuration_recorder" "main" {
  name     = "landing-zone-config-recorder"
  role_arn = aws_iam_role.config.arn

  recording_group {
    all_supported = true
  }
}

# AWS Config Delivery Channel
resource "aws_config_delivery_channel" "main" {
  name           = "landing-zone-config-delivery"
  s3_bucket_name = var.config_bucket_name
  s3_key_prefix  = "config"

  depends_on = [aws_config_configuration_recorder.main]
}

# AWS Config Configuration Recorder Status
resource "aws_config_configuration_recorder_status" "main" {
  name       = aws_config_configuration_recorder.main.name
  is_enabled = true

  depends_on = [aws_config_delivery_channel.main]
}

# AWS Config Rules
resource "aws_config_config_rule" "managed_rules" {
  for_each = var.config_rules

  name        = each.key
  description = "AWS Config managed rule: ${each.value}"

  source {
    owner             = "AWS"
    source_identifier = each.value
  }

  tags = merge(var.tags, {
    Name = each.key
  })
} 