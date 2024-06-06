# AWS Notification Service Deployment with Terraform

## Description
This repository contains the configuration files required for Notification Service Deployment on AWS.

## Prerequisites

Before deploying the infrastructure, ensure you have the following prerequisites:
- AWS CLI installed and configured with the appropriate credentials.
- Terraform installed.
- Docker installed (for building and pushing Docker images to ECR).

## Deployment Steps

### 1. Clone the Repository

```
git clone <repository_name>
```

### 2. Initialize Terraform
Run the following command to initialize the Terraform configuration:
```
terraform init
```

### 3.Configure Variables
Update the terraform.tfvars file with your AWS configuration details:
```
region                = "" # Replace with your region
subnet_ids            = ["", ""]  # Replace with your subnet IDs
security_group_ids    = [""]  # Replace with your security group IDs
vpc_id                = ""  # Replace with your VPC ID
min_task_count        = 1
max_task_count        = 10    # Can replace the count as per the requirement
desired_task_count    = 2
target_cpu_utilization = 50
```

### 4. Plan the Deployment
Run the following command to preview the changes that Terraform will make:
```
terraform plan -var-file=terraform.tfvars
```

### Apply the Configuration
Run the following command to deploy the infrastructure:
```
terraform apply -var-file=terraform.tfvars
```