# Containerized and Scalable Web Application

Route 53 + ACM, CloudFront, S3 (static), API Gateway (JWT), ALB, ECS/Fargate, DynamoDB, ECR, CloudWatch. GitHub Actions with OIDC.

## Overview

* Custom domain with HTTPS (ACM + Route 53)
* Static content via S3 → CloudFront
* Dynamic API `/api/*` via API Gateway → ALB → ECS/Fargate
* Data in DynamoDB, images in ECR
* Logs, alarms, dashboard in CloudWatch

## Repo

```
bootstrap-backend/  # S3 tfstate + DynamoDB lock (one‑time)
infrastructure/     # Terraform root (uses ../modules/*)
modules/            # network, acm, route53, s3_static, cloudfront, apigw,
                    # alb, ecs, ecr, dynamodb_app, cognito, cloudwatch, iam_github_oidc
app/                # Node/Express sample (port 3000)
.github/workflows/  # build-and-deploy.yml
```

## Prereqs

* Region: us‑east‑1. Route 53 hosted zone for your domain.
* Terraform ≥ 1.6, AWS provider ≥ 5.x, Docker, GitHub Actions enabled.

## Setup

1. **Bootstrap state**

```bash
cd bootstrap-backend && terraform init && terraform apply \
  -var 'region=us-east-1' \
  -var 'state_bucket_name=<unique-bucket>' \
  -var 'lock_table_name=tfstate-locks'
```

Update `infrastructure/backend.tf` with bucket + table.

2. **Configure vars** — edit and commit `infra/terraform.tfvars`.

3. **First apply**

```bash
cd infrastructure && terraform init -reconfigure && terraform apply -auto-approve
```

Capture `iam_ci_role_arn` and `ecr_repo_url` outputs.

## CI/CD (GitHub Actions)

* Secret: `AWS_GITHUB_ROLE_ARN` = output `iam_ci_role_arn`
* Variable: `ECR_REPO_NAME` = your repo name (e.g., `webapp`)
  Push to `main` → build to ECR (tag = commit SHA) → `terraform apply` with `TF_VAR_image_tag`.

## App

* Health: `/` → 200 for ALB
* API: `/api/health`, `/api/items` (GET/POST)
* Env: `TABLE_NAME` set in ECS task

## Observability

* Logs: `/ecs/webapp`, `/apigw/<api>`
* Dashboard: `app-observability`
* Alarms: ECS CPU, ALB 5XX, API 5XX (optional SNS email)

## Useful

```bash
# Upload static site
aws s3 sync ./static s3://static-<example-com>/ --delete

# Test API
curl -i https://<domain>/api/health
```

## Cleanup

```bash
cd infrastructure && terraform destroy -auto-approve
cd ../bootstrap-backend && terraform destroy -auto-approve
```
