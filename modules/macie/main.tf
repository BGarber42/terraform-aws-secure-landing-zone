# Macie account
resource "aws_macie2_account" "main" {
  count = var.enable_macie ? 1 : 0

  finding_publishing_frequency = var.macie_finding_publishing_frequency
  status                       = "ENABLED"
}

# Macie classification job
resource "aws_macie2_classification_job" "s3_scan" {
  count = var.enable_macie && var.enable_s3_classification ? 1 : 0

  job_type = "ONE_TIME"
  name     = "s3-classification-job"

  s3_job_definition {
    bucket_definitions {
      account_id = var.account_id
      buckets    = var.s3_buckets_to_scan
    }

    scoping {
      excludes {
        and {
          simple_scope_term {
            comparator = "EQ"
            key        = "OBJECT_EXTENSION"
            values     = var.excluded_file_extensions
          }
        }
      }
    }
  }

  depends_on = [aws_macie2_account.main]
}

# Macie custom data identifier
resource "aws_macie2_custom_data_identifier" "custom_patterns" {
  for_each = var.enable_macie ? var.custom_data_identifiers : {}

  name         = each.key
  description  = each.value.description
  regex        = each.value.regex
  keywords     = each.value.keywords
  ignore_words = each.value.ignore_words

  depends_on = [aws_macie2_account.main]
}

# Macie findings filter
resource "aws_macie2_findings_filter" "high_severity" {
  count = var.enable_macie ? 1 : 0

  name        = "high-severity-findings"
  description = "Filter for high severity findings"
  action      = "ARCHIVE"

  finding_criteria {
    criterion {
      field = "severity.description"
      eq    = ["High"]
    }
  }

  depends_on = [aws_macie2_account.main]
}

# Data sources
data "aws_region" "current" {} 