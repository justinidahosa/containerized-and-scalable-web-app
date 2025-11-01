# Containerized and Scalable Web Application on AWS
## Overview

This project deploys a containerized web application on AWS using Terraform modules and a GitHub Actions CI/CD pipeline integrated through OIDC.
The architecture demonstrates a secure, scalable, and automated deployment of cloud infrastructure and application code without using static AWS credentials.

## Architecture
### AWS Services Used

VPC, Subnets, NAT Gateway – Isolated and secure networking.

ECS Fargate & ECR – Containerized compute and image storage.

ALB, Route 53, ACM, CloudFront – HTTPS, DNS, and content delivery.

S3 (Frontend Static Assets) – Hosts static files (HTML, CSS, JS) for the frontend and integrates with CloudFront for edge caching.

DynamoDB – Serverless database for application storage.

Cognito – Authentication and user management.

CloudWatch – Monitoring and alarm management.

S3 + DynamoDB – Terraform state management and locking.

## Flow

Users access the website through CloudFront, which serves:

Static frontend content from S3.

Dynamic API requests routed to the Application Load Balancer (ALB).

The ALB forwards requests to ECS Fargate containers running the Node.js backend service.

The containers interact with DynamoDB for persistent storage.

CloudFront provides caching and global low-latency delivery.

CloudWatch continuously monitors performance and health across all layers.

## Automation
### Terraform Modules

This project is fully modularized for reusability and clarity. Key modules include:

network – VPC, subnets, route tables, gateways

alb – Application Load Balancer and target groups

ecs – Cluster, service, and task definition for Fargate

ecr – Container image registry

acm – SSL/TLS certificates

cloudfront – Global CDN integrating ALB and S3 frontend

s3_frontend – S3 bucket for static frontend assets

dynamodb – Serverless database

cognito – User authentication

route53 – DNS management and domain routing

monitoring – CloudWatch dashboards and alarms

ci_oidc – IAM role and policy for GitHub Actions OIDC integration

Remote Terraform state is stored in S3, with DynamoDB providing state locking to prevent conflicts during deployments.

## CI/CD with GitHub Actions

Builds the Docker image from the Node.js backend (/app folder).

Pushes the image to Amazon ECR.

Applies infrastructure changes using Terraform.

Syncs the static frontend files (from /frontend) to the S3 bucket, invalidating CloudFront cache for instant updates.

Uses OIDC for secure AWS access — no long-lived access keys.

## Application

A simple Node.js service containerized with Docker:

FROM node:20-alpine
WORKDIR /app
COPY server.js package*.json ./
RUN npm install --omit=dev
EXPOSE 3000
CMD ["node", "server.js"]

## Key Outcomes

Fully automated multi-tier architecture managed by Terraform.

Frontend hosted on S3, globally distributed via CloudFront.

Backend API deployed on ECS Fargate behind an ALB.

HTTPS-secured, scalable, and fault-tolerant web application.

Real-time observability via CloudWatch metrics and alarms.

Zero manual provisioning and no hard-coded credentials — all automated through GitHub Actions + OIDC.