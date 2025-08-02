resource "aws_iam_role" "app_runner_service_role" {
  name = "${var.project_name}-${var.environment}-app-runner-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apprunner.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "app_runner_service_role_policy" {
  role       = aws_iam_role.app_runner_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_iam_role" "app_runner_instance_role" {
  name = "${var.project_name}-${var.environment}-app-runner-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_apprunner_service" "backend" {
  service_name = "${var.project_name}-${var.environment}-backend"

  source_configuration {
    image_repository {
      image_configuration {
        port = "8000"
        runtime_environment_variables = {
          OPENAI_API_KEY = var.openai_api_key
        }
      }
      image_identifier      = "public.ecr.aws/aws-containers/hello-app-runner:latest"
      image_repository_type = "ECR_PUBLIC"
    }
    auto_deployments_enabled = false
  }

  instance_configuration {
    cpu               = "0.25 vCPU"
    memory            = "0.5 GB"
    instance_role_arn = aws_iam_role.app_runner_instance_role.arn
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-backend"
    Environment = var.environment
    Project     = var.project_name
  }
}

# Alternative configuration using source code (when GitHub integration is set up)
resource "aws_apprunner_service" "backend_from_source" {
  count        = 0 # Set to 1 to use this instead of the image-based service
  service_name = "${var.project_name}-${var.environment}-backend-source"

  source_configuration {
    code_repository {
      repository_url = var.github_repository
      
      source_code_version {
        type  = "BRANCH"
        value = var.github_branch
      }
      
      code_configuration {
        configuration_source = "API"
        
        code_configuration_values {
          runtime                       = "PYTHON_3"
          build_command                = "pip install -r python-backend/requirements.txt"
          start_command                = "cd python-backend && uvicorn api:app --host 0.0.0.0 --port 8000"
          runtime_environment_variables = {
            OPENAI_API_KEY = var.openai_api_key
          }
        }
      }
    }
    
    auto_deployments_enabled = true
  }

  instance_configuration {
    cpu               = "0.25 vCPU"
    memory            = "0.5 GB"
    instance_role_arn = aws_iam_role.app_runner_instance_role.arn
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-backend"
    Environment = var.environment
    Project     = var.project_name
  }
}