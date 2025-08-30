# Notification Service CI/CD Pipeline

This repository contains the CI/CD pipeline setup for the Notification Service, built in the Node.js ecosystem. The pipeline is designed to automate the build, test, and deployment processes using GitHub Actions and Terraform.

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Setup Instructions](#setup-instructions)
4. [Workflow Explanation](#workflow-explanation)
5. [Conclusion](#conclusion)

## Overview

The CI/CD pipeline automates the following processes:

- Building and testing the Notification Service application.
- Deploying the application to AWS ECS Fargate.
- Implementing logging, auto-scaling, and health checks.
- Continuous monitoring and notifications on pipeline status.

## Prerequisites

Before setting up the CI/CD pipeline, ensure you have the following:

- GitHub account with repository access.
- AWS account with IAM permissions for ECS Fargate, CloudWatch, SQS, and ECR.
- AWS access key ID and secret access key.
- Terraform installed locally or available in your CI/CD environment.

## Setup Instructions

Follow these steps to set up the CI/CD pipeline:

1. **Fork Repository**: Fork the [DevOps-Assessment](https://github.com/PearlThoughts/DevOps-Assessment) repository to your GitHub account.

2. **Configure GitHub Secrets**: Set up the following GitHub Secrets in your repository settings:
   - `AWS_ACCESS_KEY_ID`: Your AWS access key ID.
   - `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key.

3. **Define GitHub Actions Workflow**: Create a `.github/workflows/main.yml` file in your repository with the provided workflow YAML.

4. **Update Terraform Configuration**: Add Terraform configuration files (`main.tf`, `variables.tf`, etc.) to provision AWS resources.

5. **Commit and Push Changes**: Commit the changes to your repository and push them to the `main` branch.

6. **Monitor Pipeline Execution**: Monitor the workflow execution in the Actions tab of your GitHub repository. Ensure that the pipeline completes successfully.

## Workflow Explanation

The CI/CD pipeline performs the following steps:

- **Build and Test**: Checks out the code, installs dependencies, runs tests, and generates artifacts.
- **Terraform Deployment**: Initializes Terraform, plans, and applies the infrastructure changes on AWS.
- **Deployment to ECS Fargate**: Deploys the Notification Service to AWS ECS Fargate.
- **Logging, Auto-Scaling, and Health Checks**: Implements logging to CloudWatch, sets up auto-scaling based on CPU usage, and configures health checks.
- **Monitoring and Notifications**: Monitors the pipeline execution status and sends notifications on failure.

## Conclusion

With the CI/CD pipeline set up, the Notification Service can be continuously built, tested, and deployed to AWS ECS Fargate environment. This ensures efficient development, deployment, and maintenance of the application.


