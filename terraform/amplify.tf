resource "aws_iam_role" "amplify_role" {
  name = "${var.project_name}-${var.environment}-amplify-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "amplify.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "amplify_policy" {
  name = "${var.project_name}-${var.environment}-amplify-policy"
  role = aws_iam_role.amplify_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_amplify_app" "frontend" {
  name         = "${var.project_name}-${var.environment}-frontend"
  repository   = var.github_repository
  access_token = var.github_access_token

  build_spec = <<-EOT
    version: 1
    applications:
      - frontend:
          phases:
            preBuild:
              commands:
                - cd ui
                - npm ci
            build:
              commands:
                - npm run build
          artifacts:
            baseDirectory: ui/.next
            files:
              - '**/*'
          cache:
            paths:
              - ui/node_modules/**/*
        appRoot: ui
  EOT

  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  environment_variables = {
    AMPLIFY_MONOREPO_APP_ROOT = "ui"
    AMPLIFY_DIFF_DEPLOY       = "false"
    _LIVE_UPDATES             = jsonencode([{
      name = "Node.js version"
      pkg  = "node"
      type = "nvm"
      version = "18"
    }])
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-frontend"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.frontend.id
  branch_name = var.github_branch

  framework                = "Next.js - SSG"
  stage                   = "PRODUCTION"
  enable_auto_build       = true
  enable_pull_request_preview = false

  environment_variables = {
    NEXT_PUBLIC_API_URL = aws_apprunner_service.backend.service_url
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-main-branch"
    Environment = var.environment
    Project     = var.project_name
  }
}