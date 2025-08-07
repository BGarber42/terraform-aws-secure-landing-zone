output "role_arns" {
  description = "Map of IAM role names to ARNs"
  value       = { for k, v in aws_iam_role.roles : k => v.arn }
}

output "role_names" {
  description = "List of IAM role names"
  value       = [for k, v in aws_iam_role.roles : k]
}

output "role_ids" {
  description = "Map of IAM role names to IDs"
  value       = { for k, v in aws_iam_role.roles : k => v.id }
}

output "instance_profile_arn" {
  description = "ARN of the EC2 instance profile (if created)"
  value       = var.create_ec2_instance_profile ? aws_iam_instance_profile.ec2_profile[0].arn : null
}

output "instance_profile_name" {
  description = "Name of the EC2 instance profile (if created)"
  value       = var.create_ec2_instance_profile ? aws_iam_instance_profile.ec2_profile[0].name : null
} 