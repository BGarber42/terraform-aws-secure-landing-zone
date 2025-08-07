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

# GuardDuty Detector
resource "aws_guardduty_detector" "main" {
  count = var.enable_guardduty ? 1 : 0

  enable = true

  tags = merge(var.tags, {
    Name = "landing-zone-guardduty-detector"
  })
}

# GuardDuty Feature - S3 Logs
resource "aws_guardduty_detector_feature" "s3_logs" {
  count = var.enable_guardduty ? 1 : 0

  detector_id = aws_guardduty_detector.main[0].id
  name        = "S3_DATA_EVENTS"
  status      = "ENABLED"
}

# GuardDuty Feature - Malware Protection
resource "aws_guardduty_detector_feature" "malware_protection" {
  count = var.enable_guardduty ? 1 : 0

  detector_id = aws_guardduty_detector.main[0].id
  name        = "EBS_MALWARE_PROTECTION"
  status      = "ENABLED"
}

# GuardDuty Publishing Destination (S3)
resource "aws_s3_bucket" "guardduty_findings" {
  count = var.enable_guardduty ? 1 : 0

  bucket = var.guardduty_findings_bucket_name

  tags = merge(var.tags, {
    Name = "guardduty-findings-bucket"
  })

  lifecycle {
    prevent_destroy = true
  }
}

# S3 Bucket versioning for GuardDuty findings
resource "aws_s3_bucket_versioning" "guardduty_findings" {
  count  = var.enable_guardduty ? 1 : 0
  bucket = aws_s3_bucket.guardduty_findings[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket encryption for GuardDuty findings
resource "aws_s3_bucket_server_side_encryption_configuration" "guardduty_findings" {
  count  = var.enable_guardduty ? 1 : 0
  bucket = aws_s3_bucket.guardduty_findings[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 Bucket public access block for GuardDuty findings
resource "aws_s3_bucket_public_access_block" "guardduty_findings" {
  count  = var.enable_guardduty ? 1 : 0
  bucket = aws_s3_bucket.guardduty_findings[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket policy for GuardDuty findings
resource "aws_s3_bucket_policy" "guardduty_findings" {
  count  = var.enable_guardduty ? 1 : 0
  bucket = aws_s3_bucket.guardduty_findings[0].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSGuardDutyAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "guardduty.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.guardduty_findings[0].arn
      },
      {
        Sid    = "AWSGuardDutyWrite"
        Effect = "Allow"
        Principal = {
          Service = "guardduty.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.guardduty_findings[0].arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

# GuardDuty Publishing Destination
resource "aws_guardduty_publishing_destination" "main" {
  count = var.enable_guardduty ? 1 : 0

  detector_id      = aws_guardduty_detector.main[0].id
  destination_type = "S3"
  destination_arn  = aws_s3_bucket.guardduty_findings[0].arn
  kms_key_arn      = var.guardduty_kms_key_arn

  depends_on = [aws_s3_bucket_policy.guardduty_findings]
} 