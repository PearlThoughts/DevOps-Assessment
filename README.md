This project deploys two microservices, the Notification API and the Email Sender, using AWS infrastructure. The deployment leverages various AWS services to ensure scalability, reliability, and security. The key components include Docker containers, AWS ECS Fargate for container orchestration, Amazon SQS for message queuing, AWS App Mesh for service mesh capabilities, and AWS CloudWatch for monitoring and logging.

Architecture
Components
Notification API

Receives requests and queues messages in Amazon SQS.
Deployed on AWS ECS Fargate.
Email Sender

Processes messages from the SQS queue and sends emails.
Deployed on AWS ECS Fargate.
Amazon SQS

Acts as a message queue between the Notification API and Email Sender.
AWS App Mesh

Provides service mesh capabilities for managing service-to-service communication.
AWS Cloud Map

Facilitates service discovery.
Amazon ECR

Stores Docker images for both microservices.
AWS CloudWatch

Monitors application logs and metrics.
IAM Roles

Ensures least-privilege access for all services.
Prerequisites
AWS CLI configured with appropriate access.
Docker installed locally for building images.
Terraform installed locally for infrastructure provisioning.
