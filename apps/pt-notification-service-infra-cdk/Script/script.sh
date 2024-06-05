#!/bin/bash

# Replace these variables with your actual AWS details
AWS_REGION="your-region"
AWS_ACCOUNT_ID="your-account-id"

# Repository names
NOTIFICATION_API_REPO="notification-api"
EMAIL_SENDER_REPO="email-sender"

# Docker image names
NOTIFICATION_API_IMAGE="notification-api:latest"
EMAIL_SENDER_IMAGE="email-sender:latest"

# Login to AWS ECR
echo "Logging into AWS ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Create ECR repositories
echo "Creating ECR repository for $NOTIFICATION_API_REPO..."
aws ecr create-repository --repository-name $NOTIFICATION_API_REPO --region $AWS_REGION

echo "Creating ECR repository for $EMAIL_SENDER_REPO..."
aws ecr create-repository --repository-name $EMAIL_SENDER_REPO --region $AWS_REGION

# Tag and push Notification API image
echo "Tagging and pushing $NOTIFICATION_API_IMAGE..."
docker tag $NOTIFICATION_API_IMAGE $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$NOTIFICATION_API_REPO:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$NOTIFICATION_API_REPO:latest

# Tag and push Email Sender image
echo "Tagging and pushing $EMAIL_SENDER_IMAGE..."
docker tag $EMAIL_SENDER_IMAGE $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$EMAIL_SENDER_REPO:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$EMAIL_SENDER_REPO:latest

echo "All images have been successfully pushed to ECR."
