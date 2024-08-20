CI/CD Pipeline with Zero-Downtime Deployment for Notification API and Email Sender
## Overview
This project implements a Notification API and Email Sender microservices using AWS ECS Fargate. The infrastructure is provisioned using Terraform, and a CI/CD pipeline is set up using GitHub Actions to automate the deployment process. The deployment strategy ensures zero downtime by using rolling updates.

## Requirements
Tools and Services
Infrastructure as Code (IaC) Tools:
  Terraform

## AWS Services:

ECS Fargate
Amazon SQS
AWS App Mesh
AWS Cloud Map
Amazon ECR
Amazon CloudWatch
AWS IAM
AWS SES
## Deployment Requirements
Scalability and Reliability:

Implement auto-scaling based on CPU usage (70% threshold).
Ensure system resilience and automatic recovery from failures.
## Observability:

Set up monitoring and logging using AWS CloudWatch.
Track key metrics such as queue length, processing times, and error rates.
## Security:

Implement least-privilege IAM roles.
Securely store sensitive information using AWS Secrets Manager 
## Architecture
Components
Notification API (ECS/Fargate): Receives requests and queues them into Amazon SQS.
Email Sender (ECS/Fargate): Processes queued messages and sends emails using AWS SES.
AWS App Mesh: Provides service mesh capabilities for the microservices.
AWS Cloud Map: Facilitates service discovery for microservices.
Amazon SQS: Queues messages between the Notification API and Email Sender.
Amazon CloudWatch: Monitors the system and logs application output.
Workflow
Client Request: Client sends a notification request to the Notification API.
Notification API: The API queues the request into Amazon SQS.
Email Sender: Processes the SQS message and sends an email using AWS SES.
Monitoring: CloudWatch monitors the system performance and logs.
Infrastructure as Code (IaC)
## Terraform Modules
The infrastructure is provisioned using Terraform with the following modules:

VPC: Creates a custom VPC with public and private subnets, internet gateway, NAT gateway, and route tables.
ECS: Manages the ECS cluster, task definitions, and services for Notification API and Email Sender.
ECR: Creates ECR repositories for storing Docker images.
SQS: Manages the SQS queue for message handling.
SES: Configures SES for sending emails.
IAM: Manages IAM roles and policies.
App Mesh: Configures AWS App Mesh for service mesh capabilities.
Cloud Map: Manages service discovery using AWS Cloud Map.
Load Balancer: Creates and configures an Application Load Balancer (ALB).
CloudWatch: Configures monitoring and logging using CloudWatch.
Terraform Configuration
Below is the Terraform configuration structure used in this project:
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── .terraform/
├── modules/
│   ├── vpc/
│   ├── ecs/
│   ├── ecr/
│   ├── sqs/
│   ├── ses/
│   ├── iam/
│   ├── appmesh/
│   ├── cloudmap/
│   ├── load_balancer/
│   ├── cloudwatch/
└── .gitignore
## CI/CD Pipeline
GitHub Actions Workflow
A GitHub Actions workflow is configured to automate the CI/CD process, including building Docker images, pushing them to Amazon ECR, and deploying the infrastructure using Terraform.

Workflow File: .github/workflows/ci-cd-pipeline.yml
yaml
Copy code
name: CI/CD Pipeline with Zero-Downtime Deployment

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2

      - name: Log in to Amazon ECR
        id: login-ecr
        uses: aws-actions/amazon-ecr-login@v1

      - name: Build and Push Docker Image for Notification Service
        run: |
          IMAGE_URI=${{ secrets.ECR_URI }}/notification-app:${{ github.sha }}
          docker build -t $IMAGE_URI -f ./notification-app/Dockerfile .
          docker push $IMAGE_URI

      - name: Build and Push Docker Image for Email Service
        run: |
          IMAGE_URI=${{ secrets.ECR_URI }}/email-service-app:${{ github.sha }}
          docker build -t $IMAGE_URI -f ./email-service-app/Dockerfile .
          docker push $IMAGE_URI

      - name: Deploy Infrastructure with Terraform
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          cd terraform
          terraform init
          terraform apply -auto-approve \
            -var="notification_image=${{ secrets.ECR_URI }}/notification-app:${{ github.sha }}" \
            -var="email_image=${{ secrets.ECR_URI }}/email-service-app:${{ github.sha }}"

      - name: Update ECS Service for Rolling Deployment
        run: |
          aws ecs update-service \
            --cluster notification-cluster \
            --service notification-service \
            --force-new-deployment \
            --region us-east-1

      - name: Monitor Deployment
        run: |
          aws ecs wait services-stable \
            --cluster notification-cluster \
            --services notification-service \
            --region us-east-1
## Deployment Steps
Checkout Code: The code is checked out from the repository.
Docker Buildx: Docker Buildx is set up for building multi-platform Docker images.
Amazon ECR Login: The GitHub Actions workflow logs in to Amazon ECR to push Docker images.
Build and Push Docker Images: Docker images for Notification API and Email Sender are built and pushed to ECR.
Terraform Deployment: The infrastructure is provisioned using Terraform, with image URIs passed as variables.
Rolling Deployment: The ECS service is updated to trigger a rolling deployment, ensuring zero downtime.
Monitor Deployment: The deployment is monitored to ensure the service is running as expected.
Zero-Downtime Deployment
The deployment strategy involves updating the ECS services incrementally (rolling update), which ensures that new tasks are started before the old ones are stopped, minimizing downtime.

## Testing and Verification
Health Checks: ECS health checks are configured to ensure the application is healthy before serving traffic.
Load Balancer: The Application Load Balancer (ALB) is configured to route traffic to the healthy tasks.
Monitoring: CloudWatch monitors the ECS cluster, logging metrics such as CPU utilization, memory usage, and task health.
Testing: Automated tests and manual verification ensure that the services are functioning correctly after deployment.
Documentation and Operational Instructions
Configuration
Environment Variables: Store sensitive information (like AWS credentials, SQS URLs, etc.) in .env files or secrets manager.
Terraform Variables: Configure Terraform variables for region, cluster name, image URIs, etc., in variables.tf.
## Running the Pipeline
Push changes to the main branch to trigger the GitHub Actions workflow.
Monitor the pipeline execution in the GitHub Actions tab.
Rolling Back
If issues are detected, revert to the previous task definition in ECS, or manually rollback using AWS CLI.
Known Issues
SQS Queue Messages Not Received: Ensure the correct SQS queue URL is used, and the IAM roles have the necessary permissions.
## Next Steps
Implement additional monitoring and alerting in CloudWatch.
Explore Canary deployments as an enhancement to zero-downtime strategies.
## Conclusion
This project demonstrates the deployment of microservices on AWS using a robust CI/CD pipeline with Terraform, Docker, and GitHub Actions. The focus on scalability, resilience, observability, and security ensures that the infrastructure is production-ready and can handle real-world demands.

Hands-on in the implementation:

vidhyathiruvenkadam@vidhyas-Air notification-app % curl -X POST http://ecs-lb-1211125363.us-east-1.elb.amazonaws.com/health
ok%

vidhyathiruvenkadam@vidhyas-Air notification-app % curl -X POST http://ecs-lb-1211125363.us-east-1.elb.amazonaws.com/send-notification \
-H "Content-Type: application/json" \
-d '{"message": "Dear ones, I think it is possible for ordinary people to choose to be extraordinary!"}'
Notification queued successfully%                                                                                                    
vidhyathiruvenkadam@vidhyas-Air notification-app %