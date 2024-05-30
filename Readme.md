# Notification Service Infrastructure

This repository contains the Terraform code and CI/CD pipeline setup for deploying the Notification Service and Email Sender microservices to AWS ECS Fargate.

## Directory Structure

- `autoscaling.tf`: Auto-scaling configuration for ECS services.
- `cluster.tf`: ECS cluster configuration.
- `ecr.tf`: Amazon ECR repository configurations.
- `main.tf`: Main VPC and networking configuration.
- `provider.tf`: AWS provider configuration.
- `secrets-manager.tf`: AWS Secrets Manager configuration for storing sensitive data.
- `service.tf`: ECS service and task definition configurations.
- `README.md`: Documentation.

## Deployment Process

1. **Review Microservices**: Ensure the Notification API and Email Sender microservices are correctly set up.
2. **Design Deployment**: Plan for scalability, reliability, and security.
3. **Create Dockerfiles**: Write and test Dockerfiles for both microservices.
4. **Push to Amazon ECR**: Build and push Docker images to ECR.
5. **Provision Infrastructure**: Use Terraform to provision AWS infrastructure.
6. **Deploy Services**: Deploy microservices using ECS Fargate.
7. **Implement Logging**: Configure ECS to log to CloudWatch.
8. **Auto-Scaling Configuration**: Set up auto-scaling based on CPU usage.
9. **Health Check**: Configure health checks in ECS.
10. **Test and Verify**: Ensure the services are functioning and scalable.
11. **Document**: Update documentation with deployment and operational instructions.

## CI/CD Pipeline

The CI/CD pipeline is configured using GitHub Actions to automate the build and deployment process. We can see the code in **.github/workflows/deploy.yml** file in our repository:

## Build, tag, and push images:
```docker build -t notification-api .
docker tag notification-api:latest <aws_account_id>.dkr.ecr.us-west-2.amazonaws.com/notification-api:latest
docker push <aws_account_id>.dkr.ecr.us-west-2.amazonaws.com/notification-api:latest

docker build -t email-sender .
docker tag email-sender:latest <aws_account_id>.dkr.ecr.us-west-2.amazonaws.com/email-sender:latest
docker push <aws_account_id>.dkr.ecr.us-west-2.amazonaws.com/email-sender:latest
```

### Zero-Downtime Deployment

- **Load Balancer**: Use ALB for routing traffic.
- **Blue-Green Deployment**: Implement blue-green deployment strategy for seamless updates.

For detailed steps and commands, refer to the individual Terraform and Dockerfile comments and the GitHub Actions workflow file in our repository.
