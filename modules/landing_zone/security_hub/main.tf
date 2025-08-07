terraform {
  required_version = ">= 1.12.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
}

# Security Hub administrator account
resource "aws_securityhub_account" "main" {
  count = var.enable_security_hub ? 1 : 0
}

# Security Hub standards
resource "aws_securityhub_standards_subscription" "cis_aws_foundations" {
  count = var.enable_security_hub && var.enable_cis_standard ? 1 : 0

  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/cis-aws-foundations-benchmark/v/1.2.0"

  depends_on = [aws_securityhub_account.main]
}

resource "aws_securityhub_standards_subscription" "pci_dss" {
  count = var.enable_security_hub && var.enable_pci_standard ? 1 : 0

  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/pci-dss/v/3.2.1"

  depends_on = [aws_securityhub_account.main]
}

# Security Hub actions
resource "aws_securityhub_action_target" "sns" {
  count = var.enable_security_hub && var.enable_action_targets ? 1 : 0

  identifier = "SendToSNS"
  name       = "Send findings to SNS"

  depends_on = [aws_securityhub_account.main]
}

# Security Hub insights
resource "aws_securityhub_insight" "high_severity_findings" {
  count = var.enable_security_hub ? 1 : 0

  group_by_attribute = "SeverityLabel"
  name               = "High Severity Findings"

  filters {
    severity_label {
      eq = ["HIGH", "CRITICAL"]
    }
  }

  depends_on = [aws_securityhub_account.main]
}

resource "aws_securityhub_insight" "failed_compliance_checks" {
  count = var.enable_security_hub ? 1 : 0

  group_by_attribute = "ComplianceStatus"
  name               = "Failed Compliance Checks"

  filters {
    compliance_status {
      eq = ["FAILED"]
    }
  }

  depends_on = [aws_securityhub_account.main]
}

# Data sources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {} 