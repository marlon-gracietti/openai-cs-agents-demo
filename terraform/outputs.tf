output "app_runner_service_url" {
  description = "The URL of the App Runner service"
  value       = aws_apprunner_service.backend.service_url
}

output "app_runner_service_arn" {
  description = "The ARN of the App Runner service"
  value       = aws_apprunner_service.backend.arn
}

output "amplify_app_id" {
  description = "The ID of the Amplify app"
  value       = aws_amplify_app.frontend.id
}

output "amplify_default_domain" {
  description = "The default domain of the Amplify app"
  value       = aws_amplify_app.frontend.default_domain
}

output "amplify_branch_url" {
  description = "The URL of the main branch"
  value       = "https://${var.github_branch}.${aws_amplify_app.frontend.default_domain}"
}