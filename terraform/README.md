# Terraform Infrastructure

This directory contains Terraform configuration for deploying the OpenAI CS Agents Demo to AWS using Amplify and App Runner.

## Architecture

- **Frontend**: Next.js app deployed via AWS Amplify
- **Backend**: Python FastAPI app deployed via AWS App Runner

## Prerequisites

1. AWS CLI configured with appropriate credentials
2. Terraform installed (>= 1.0)
3. GitHub repository connected to AWS Amplify

## Deployment

1. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` with your values:
   - Update `github_repository` with your GitHub repo URL
   - Add your OpenAI API key
   - Adjust region and environment as needed

3. Initialize and deploy:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Configuration Notes

### App Runner
- Configured with 0.25 vCPU and 0.5 GB memory (cost-effective)
- Two configurations provided:
  - Image-based (default): Uses a placeholder image
  - Source-based (commented out): Deploys directly from GitHub

### Amplify
- Configured for Next.js with SSG
- Monorepo setup with `ui/` as the app root
- Auto-deployment enabled from the main branch
- Environment variable `NEXT_PUBLIC_API_URL` automatically set to App Runner URL

## Costs (Approximate)
- App Runner: ~$25-50/month
- Amplify: ~$1-15/month
- Total: ~$26-65/month

## Cleanup

To destroy all resources:
```bash
terraform destroy
```