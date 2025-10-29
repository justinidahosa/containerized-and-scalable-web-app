Containerized and Scalable Web Application on AWS
Overview

This project deploys a containerized web application on AWS using Terraform modules and a GitHub Actions CI/CD pipeline integrated through OIDC.
The architecture demonstrates a secure, scalable, and automated deployment of cloud infrastructure and application code without using static AWS credentials.

Architecture

AWS Services Used

VPC, Subnets, NAT Gateway – Isolated and secure networking.

ECS Fargate & ECR – Containerized compute and image storage.

ALB, Route 53, ACM, CloudFront – HTTPS, DNS, and content delivery.

DynamoDB – Serverless database for application storage.

Cognito – Authentication and user management.

CloudWatch – Monitoring and alarm management.

S3 + DynamoDB – Terraform state management and locking.

Flow
Users access the app through CloudFront or the ALB (HTTPS).
Traffic routes to ECS Fargate containers, which interact with DynamoDB.
CloudWatch provides metrics and operational visibility.

Automation

Terraform Modules

Network, ALB, ECS, DynamoDB, ACM, CloudFront, Cognito, Route 53, and Monitoring.

Remote backend stored in S3 with DynamoDB state locking.

CI/CD with GitHub Actions

Builds Docker image from Node.js app.

Pushes image to ECR.

Deploys infrastructure and services with Terraform.

Uses OIDC for secure AWS access (no static credentials).

Application

Simple Node.js service containerized with Docker:

FROM node:20-alpine
WORKDIR /app
COPY server.js package*.json ./
RUN npm install --omit=dev
EXPOSE 3000
CMD ["node", "server.js"]

Key Outcomes

Fully automated infrastructure and deployment using Terraform and OIDC.

HTTPS-secured, scalable, and fault-tolerant web app architecture.

Real-time monitoring with CloudWatch and serverless DynamoDB backend.

No hard-coded credentials or manual provisioning required.
