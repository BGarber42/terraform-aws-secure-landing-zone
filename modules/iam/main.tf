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

# IAM Roles
resource "aws_iam_role" "roles" {
  for_each = { for role in var.iam_roles : role.name => role }

  name        = each.value.name
  description = each.value.description

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${var.account_id}:root"
        }
      }
    ]
  })

  permissions_boundary = each.value.permission_boundary

  tags = merge(var.tags, {
    Name = each.value.name
  })
}

# IAM Role Policy Attachments
resource "aws_iam_role_policy_attachment" "managed_policies" {
  for_each = {
    for role in var.iam_roles : role.name => role
    if role.policy_arn != null
  }

  role       = aws_iam_role.roles[each.key].name
  policy_arn = each.value.policy_arn
}

# IAM Inline Policies
resource "aws_iam_role_policy" "inline_policies" {
  for_each = {
    for role in var.iam_roles : role.name => role
    if role.inline_policy != null
  }

  name   = "${each.key}-inline-policy"
  role   = aws_iam_role.roles[each.key].id
  policy = each.value.inline_policy
}

# IAM Instance Profile for EC2 (if needed)
resource "aws_iam_instance_profile" "ec2_profile" {
  count = var.create_ec2_instance_profile ? 1 : 0
  name  = "landing-zone-ec2-profile"
  role  = aws_iam_role.roles["EC2Role"].name

  tags = merge(var.tags, {
    Name = "landing-zone-ec2-profile"
  })
} 