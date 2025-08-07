output "budget_id" {
  description = "ID of the cost budget"
  value       = var.enable_budget_alerts ? aws_budgets_budget.cost[0].id : null
}

output "budget_arn" {
  description = "ARN of the cost budget"
  value       = var.enable_budget_alerts ? aws_budgets_budget.cost[0].arn : null
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for budget alerts"
  value       = var.enable_budget_alerts ? aws_sns_topic.budget[0].arn : null
}

output "sns_topic_name" {
  description = "Name of the SNS topic for budget alerts"
  value       = var.enable_budget_alerts ? aws_sns_topic.budget[0].name : null
}

output "budget_action_arn" {
  description = "ARN of the budget action (if enabled)"
  value       = var.enable_budget_alerts && var.enable_budget_actions ? aws_budgets_budget_action.cost_control[0].arn : null
}

output "budget_action_role_arn" {
  description = "ARN of the IAM role for budget actions"
  value       = var.enable_budget_alerts && var.enable_budget_actions ? aws_iam_role.budget_action[0].arn : null
} 