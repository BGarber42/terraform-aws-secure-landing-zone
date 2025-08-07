# S3 Bucket for CloudTrail logs (with prevent_destroy)
# security:disable-bucket-logging-requirement
# This bucket is used exclusively by CloudTrail service and does not require access logging
resource "aws_s3_bucket" "cloudtrail_protected" {
  count = var.prevent_destroy ? 1 : 0

  bucket = var.cloudtrail_bucket_name

  tags = merge(var.tags, {
    Name = "cloudtrail-logs-bucket"
  })

  lifecycle {
    prevent_destroy = true
  }
}

# S3 Bucket for CloudTrail logs (without prevent_destroy)
# security:disable-bucket-logging-requirement
# This bucket is used exclusively by CloudTrail service and does not require access logging
resource "aws_s3_bucket" "cloudtrail_unprotected" {
  count = var.prevent_destroy ? 0 : 1

  bucket = var.cloudtrail_bucket_name

  tags = merge(var.tags, {
    Name = "cloudtrail-logs-bucket"
  })
}

# Use the appropriate bucket based on prevent_destroy setting
locals {
  cloudtrail_bucket = var.prevent_destroy ? aws_s3_bucket.cloudtrail_protected[0] : aws_s3_bucket.cloudtrail_unprotected[0]
}

# S3 Bucket versioning
resource "aws_s3_bucket_versioning" "cloudtrail" {
  bucket = local.cloudtrail_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 Bucket server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {
  bucket = local.cloudtrail_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.s3_encryption_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# S3 Bucket public access block
resource "aws_s3_bucket_public_access_block" "cloudtrail" {
  bucket = local.cloudtrail_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket lifecycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail" {
  bucket = local.cloudtrail_bucket.id

  rule {
    id     = "cloudtrail-lifecycle"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = 365
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

# S3 Bucket policy
resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = local.cloudtrail_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = local.cloudtrail_bucket.arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${local.cloudtrail_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Sid    = "AWSConfigAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = local.cloudtrail_bucket.arn
      },
      {
        Sid    = "AWSConfigLocation"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = "s3:GetBucketLocation"
        Resource = local.cloudtrail_bucket.arn
      },
      {
        Sid    = "AWSConfigWrite"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${local.cloudtrail_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

# CloudTrail
resource "aws_cloudtrail" "main" {
  name                          = "landing-zone-cloudtrail"
  s3_bucket_name                = local.cloudtrail_bucket.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  enable_log_file_validation    = true

  kms_key_id = var.cloudtrail_enable_kms ? var.s3_encryption_key_arn : null

  event_selector {
    read_write_type                  = "All"
    include_management_events        = true
    exclude_management_event_sources = ["kms.amazonaws.com"]
  }

  tags = merge(var.tags, {
    Name = "landing-zone-cloudtrail"
  })

  depends_on = [aws_s3_bucket_policy.cloudtrail]
} 