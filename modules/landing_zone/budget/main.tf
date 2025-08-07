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

# SNS Topic for budget notifications
resource "aws_sns_topic" "budget" {
  count = var.enable_budget_alerts ? 1 : 0

  name = "landing-zone-budget-alerts"

  tags = merge(var.tags, {
    Name = "landing-zone-budget-alerts"
  })
}

# SNS Topic Policy for budget notifications
resource "aws_sns_topic_policy" "budget" {
  count = var.enable_budget_alerts ? 1 : 0

  arn = aws_sns_topic.budget[0].arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "budgets.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.budget[0].arn
      }
    ]
  })
}

# SNS Topic Subscriptions
resource "aws_sns_topic_subscription" "budget" {
  for_each = var.enable_budget_alerts ? toset(var.budget_alert_subscribers) : toset([])

  topic_arn = aws_sns_topic.budget[0].arn
  protocol  = "email"
  endpoint  = each.value
}

# Budget
resource "aws_budgets_budget" "cost" {
  count = var.enable_budget_alerts ? 1 : 0

  name         = "landing-zone-cost-budget"
  budget_type  = "COST"
  time_unit    = "MONTHLY"
  limit_amount = var.budget_limit_usd
  limit_unit   = "USD"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.budget_alert_subscribers
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.budget_alert_subscribers
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 120
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.budget_alert_subscribers
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 150
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.budget_alert_subscribers
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 200
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.budget_alert_subscribers
  }

  tags = merge(var.tags, {
    Name = "landing-zone-cost-budget"
  })
}

# Budget Action (optional - for automated responses)
resource "aws_budgets_budget_action" "cost_control" {
  count = var.enable_budget_alerts && var.enable_budget_actions ? 1 : 0

  budget_name        = aws_budgets_budget.cost[0].name
  action_type        = "APPLY_IAM_POLICY"
  approval_model     = "AUTOMATIC"
  execution_role_arn = aws_iam_role.budget_action[0].arn

  action_threshold {
    action_threshold_type  = "PERCENTAGE"
    action_threshold_value = 200
  }

  definition {
    iam_action_definition {
      policy_arn = "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
    }
  }

  subscribers {
    address           = var.budget_alert_subscribers[0]
    subscription_type = "EMAIL"
  }
}

# IAM Role for Budget Actions
resource "aws_iam_role" "budget_action" {
  count = var.enable_budget_alerts && var.enable_budget_actions ? 1 : 0

  name = "budget-action-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "budgets.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "budget-action-role"
  })
}

# IAM Role Policy for Budget Actions
resource "aws_iam_role_policy" "budget_action" {
  count = var.enable_budget_alerts && var.enable_budget_actions ? 1 : 0

  name = "budget-action-policy"
  role = aws_iam_role.budget_action[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:AttachUserPolicy",
          "iam:DetachUserPolicy",
          "iam:AttachGroupPolicy",
          "iam:DetachGroupPolicy",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy"
        ]
        Resource = "*"
      }
    ]
  })
} 