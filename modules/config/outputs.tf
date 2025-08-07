output "recorder_name" {
  description = "Name of the AWS Config recorder"
  value       = aws_config_configuration_recorder.main.name
}

output "delivery_channel_name" {
  description = "Name of the AWS Config delivery channel"
  value       = aws_config_delivery_channel.main.name
}

output "rule_arns" {
  description = "Map of Config rule names to ARNs"
  value       = { for k, v in aws_config_config_rule.managed_rules : k => v.arn }
}

output "rule_names" {
  description = "List of Config rule names"
  value       = [for k, v in aws_config_config_rule.managed_rules : k]
}

output "iam_role_arn" {
  description = "ARN of the IAM role used by AWS Config"
  value       = aws_iam_role.config.arn
} 