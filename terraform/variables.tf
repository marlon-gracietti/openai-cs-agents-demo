variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "openai-cs-agents-demo"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "github_repository" {
  description = "GitHub repository URL"
  type        = string
  default     = "https://github.com/marlon-gracietti/openai-cs-agents-demo"
}

variable "github_branch" {
  description = "GitHub branch to deploy"
  type        = string
  default     = "main"
}

variable "openai_api_key" {
  description = "OpenAI API key for the backend"
  type        = string
  sensitive   = true
}