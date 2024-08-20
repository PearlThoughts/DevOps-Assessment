# Terraform Infrastructure Deployment

This repository contains Terraform configurations for deploying a microservices-based architecture on AWS. The deployment includes services like the **Notification API** and **Email Sender** running on AWS ECS Fargate, along with supporting services like AWS App Mesh, Cloud Map, SQS, and more.

## Table of Contents

- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Modules](#modules)
  - [VPC](#vpc)
  - [ECR](#ecr)
  - [SQS](#sqs)
  - [IAM](#iam)
  - [ECS](#ecs)
  - [Health Check](#health-check)
  - [Load Balancer](#load-balancer)
  - [Auto Scaling](#auto-scaling)
  - [App Mesh](#app-mesh)
  - [Cloud Map](#cloud-map)
  - [CloudWatch](#cloudwatch)
  - [SES](#ses)
- [Usage](#usage)
- [CI/CD Pipeline](#cicd-pipeline)
- [Contributing](#contributing)
- [License](#license)



- **main.tf**: Main Terraform configuration file where resources are defined.
- **variables.tf**: Input variables for the Terraform modules.
- **modules/**: Directory containing all the Terraform modules used in the project.

## Prerequisites

Before you begin, ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads) v1.0.0 or higher
- [AWS CLI](https://aws.amazon.com/cli/)
- An AWS account with the necessary permissions to deploy the resources.

## Modules

### VPC
The `vpc` module provisions a Virtual Private Cloud (VPC) with public and private subnets, internet gateway, NAT gateway, and appropriate route tables.

### ECR
The `ecr` module creates Amazon Elastic Container Registry (ECR) repositories for storing Docker images.

### SQS
The `sqs` module provisions an Amazon Simple Queue Service (SQS) queue used for messaging between services.

### IAM
The `iam` module creates the necessary IAM roles and policies for ECS tasks.

### ECS
The `ecs` module deploys the ECS cluster and services (Notification API and Email Sender) on AWS Fargate.

### Health Check
The `health_check` module configures health checks for the ECS services.

### Load Balancer
The `load_balancer` module provisions an Application Load Balancer (ALB) and associates it with the ECS services.

### Auto Scaling
The `autoscaling` module sets up auto-scaling policies based on CPU utilization.

### App Mesh
The `appmesh` module integrates AWS App Mesh to provide service mesh capabilities.

### Cloud Map
The `cloudmap` module sets up AWS Cloud Map for service discovery.

### CloudWatch
The `cloudwatch` module configures CloudWatch dashboards for monitoring ECS service metrics.

### SES
The `ses` module configures Amazon Simple Email Service (SES) for sending emails.

## Usage

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-repo/terraform-infrastructure.git
   cd terraform-infrastructure
Configure AWS CLI:
Make sure your AWS CLI is configured with the appropriate credentials:


>> aws configure
Initialize Terraform:
Initialize the Terraform working directory:


>> terraform init
Apply the Terraform Configuration:
Deploy the infrastructure:


>> terraform apply -auto-approve
This command will create all the necessary resources in your AWS account.

Monitor the Deployment:
After deployment, monitor the services using the AWS Management Console and CloudWatch.

CI/CD Pipeline
A GitHub Actions workflow is set up to automate the deployment process. When you push changes to the main branch, the workflow will:

Build Docker images for the Notification API and Email Sender services.
Push the Docker images to Amazon ECR.
Deploy the infrastructure using Terraform.
Ensure that the GitHub repository secrets are configured for AWS credentials and ECR URI.

