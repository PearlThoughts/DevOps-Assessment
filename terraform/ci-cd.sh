docker build -t notificationapp .
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_REPO_URL
docker tag notificationapp $ECR_REPO_URL:latest
docker push $ECR_REPO_URL:latest