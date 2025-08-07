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

# GuardDuty Publishing Destination (S3) - with prevent_destroy
resource "aws_s3_bucket" "guardduty_findings_protected" {
  count  = var.enable_guardduty && var.guardduty_findings_bucket_name != "" && var.prevent_destroy ? 1 : 0
  bucket = var.guardduty_findings_bucket_name
  tags = merge(var.tags, {
    Name = "guardduty-findings-bucket"
  })
  # lifecycle {
  #   prevent_destroy = true
  # }
}

# GuardDuty Publishing Destination (S3) - without prevent_destroy
resource "aws_s3_bucket" "guardduty_findings_unprotected" {
  count = var.enable_guardduty && var.guardduty_findings_bucket_name != "" && !var.prevent_destroy ? 1 : 0

  bucket = var.guardduty_findings_bucket_name

  tags = merge(var.tags, {
    Name = "guardduty-findings-bucket"
  })
}

# Use the appropriate bucket based on prevent_destroy setting
locals {
  guardduty_bucket = var.prevent_destroy ? aws_s3_bucket.guardduty_findings_protected[0] : aws_s3_bucket.guardduty_findings_unprotected[0]
}

# S3 Bucket versioning for GuardDuty findings
resource "aws_s3_bucket_versioning" "guardduty_findings" {
  count  = var.enable_guardduty && var.guardduty_findings_bucket_name != "" ? 1 : 0
  bucket = local.guardduty_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket encryption for GuardDuty findings
resource "aws_s3_bucket_server_side_encryption_configuration" "guardduty_findings" {
  count  = var.enable_guardduty && var.guardduty_findings_bucket_name != "" ? 1 : 0
  bucket = local.guardduty_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.s3_encryption_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# S3 Bucket public access block for GuardDuty findings
resource "aws_s3_bucket_public_access_block" "guardduty_findings" {
  count  = var.enable_guardduty && var.guardduty_findings_bucket_name != "" ? 1 : 0
  bucket = local.guardduty_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket policy for GuardDuty findings
resource "aws_s3_bucket_policy" "guardduty_findings" {
  count  = var.enable_guardduty && var.guardduty_findings_bucket_name != "" ? 1 : 0
  bucket = local.guardduty_bucket.id
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
        Resource = local.guardduty_bucket.arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.account_id
          }
          StringLike = {
            "aws:SourceArn" = "arn:aws:guardduty:${var.region}:${var.account_id}:detector/*"
          }
        }
      },
      {
        Sid    = "AWSGuardDutyLocation"
        Effect = "Allow"
        Principal = {
          Service = "guardduty.amazonaws.com"
        }
        Action   = "s3:GetBucketLocation"
        Resource = local.guardduty_bucket.arn
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.account_id
          }
          StringLike = {
            "aws:SourceArn" = "arn:aws:guardduty:${var.region}:${var.account_id}:detector/*"
          }
        }
      },
      {
        Sid    = "AWSGuardDutyWrite"
        Effect = "Allow"
        Principal = {
          Service = "guardduty.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${local.guardduty_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = var.account_id
            "s3:x-amz-acl"      = "bucket-owner-full-control"
          }
          StringLike = {
            "aws:SourceArn" = "arn:aws:guardduty:${var.region}:${var.account_id}:detector/*"
          }
        }
      }
    ]
  })
}

# GuardDuty Publishing Destination
resource "aws_guardduty_publishing_destination" "main" {
  count = var.enable_guardduty && var.guardduty_findings_bucket_name != "" ? 1 : 0

  detector_id      = aws_guardduty_detector.main[0].id
  destination_type = "S3"
  destination_arn  = local.guardduty_bucket.arn
  kms_key_arn      = var.s3_encryption_key_arn

  depends_on = [aws_s3_bucket_policy.guardduty_findings]
} 