terraform {
  backend "s3"{
    bucket                 = "saadterraform"
    region                 = "ap-south-1"
    key                    = "pt.tfstate"
  }
}

# Define provider
provider "aws" {
  region = "ap-south-1" # Change to your preferred region
}

# Use default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch subnet IDs using the new data source
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
# Fetch the default security group
data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

# Define the IAM policy to allow ECS Task Role to interact with the SQS queue
resource "aws_iam_policy" "sqs_access_policy" {
  name        = "sqs-access-policy"
  description = "Policy to allow ECS Task Role to interact with the SQS FIFO queue"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Action: [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl"
        ],
        Resource: aws_sqs_queue.fifo_message_queue.arn  # Reference the ARN of the SQS queue
      }
    ]
  })
}

# Reference the existing IAM role
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"  # Reference the existing role by name
}

# Attach necessary policies to the ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = data.aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.sqs_access_policy.arn
}

# Create a FIFO SQS Queue
resource "aws_sqs_queue" "fifo_message_queue" {
  name                           = "pt_queue.fifo"   # FIFO queues must have a .fifo suffix
  fifo_queue                     = true                   # Enable FIFO queue
  content_based_deduplication    = true                   # Enable content-based deduplication
  deduplication_scope            = "queue"                # Deduplication scope at the queue level
  fifo_throughput_limit          = "perQueue"             # Set FIFO throughput limit to Per Queue
}

# Create ECR Repositories
data "aws_ecr_repository" "notification_api" {
  name = "notification_api"
}

data "aws_ecr_repository" "email_sender" {
  name = "email_sender"
}

# Create ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "pt-cluster"
}

# resource "aws_ecs_cluster_capacity_providers" "cluster_capacity" {
#   cluster_name = aws_ecs_cluster.ecs_cluster.name

#   capacity_provider_strategy {
#     capacity_provider = "Fargate"
#     base = 2
#     weight = 1
#   }
# }

resource "aws_cloudwatch_log_group" "notification" {
  name = "/ecs/notification_api"
}

resource "aws_cloudwatch_log_group" "email" {
  name = "/ecs/email_sender"
}

# Create ECS Task Definition for Notification API
resource "aws_ecs_task_definition" "notification_api" {
  family                   = "notification-api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"  # 0.25 vCPU
  memory                   = "3072"  # 0.5 GB
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role.arn
  # Runtime platform configuration to specify OS and architecture
  runtime_platform {
    operating_system_family = "LINUX"         # Options: LINUX, WINDOWS_SERVER_2019_CORE, WINDOWS_SERVER_2019_FULL, etc.
    cpu_architecture        = "X86_64"        # Options: X86_64, ARM64
  }
  container_definitions = jsonencode([
    {
      name      = "notification-container"
      image     = "${data.aws_ecr_repository.notification_api.repository_url}:latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      # Log configuration for CloudWatch
      logConfiguration = {
        logDriver = "awslogs"
        options = {
            awslogs-group         = "/ecs/notification_api"   # CloudWatch Logs group
            awslogs-region        = "ap-south-1"               # Region where logs will be sent
            awslogs-stream-prefix = "ecs"                     # Stream prefix
            }
        } 
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "QUEUE_URL"
          value = aws_sqs_queue.fifo_message_queue.id
        }
      ]
    }
  ])
}

# Create ECS Task Definition for Email Sender
resource "aws_ecs_task_definition" "email_sender" {
  family                   = "email-sender-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"  # 0.25 vCPU
  memory                   = "3072"  # 0.5 GB
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = data.aws_iam_role.ecs_task_execution_role.arn
  # Runtime platform configuration to specify OS and architecture
  runtime_platform {
    operating_system_family = "LINUX"         # Options: LINUX, WINDOWS_SERVER_2019_CORE, WINDOWS_SERVER_2019_FULL, etc.
    cpu_architecture        = "X86_64"        # Options: X86_64, ARM64
  }
  container_definitions = jsonencode([
    {
      name      = "email-container"
      image     = "${data.aws_ecr_repository.email_sender.repository_url}:latest"
      cpu       = 1024
      memory    = 2048
      essential = true
      # Log configuration for CloudWatch
      logConfiguration = {
        logDriver = "awslogs"
        options = {
            awslogs-group         = "/ecs/email_sender"   # CloudWatch Logs group
            awslogs-region        = "ap-south-1"               # Region where logs will be sent
            awslogs-stream-prefix = "ecs"                     # Stream prefix
            }
        } 
      environment = [
        {
          name  = "QUEUE_URL"
          value = aws_sqs_queue.fifo_message_queue.id
        }
      ]
    }
  ])
}

# Define existing service discovery services
data "aws_service_discovery_service" "email_service" {
  name      = "email-service"
  namespace_id = "ns-2fby6vpoz4756jcj"
}

data "aws_service_discovery_service" "notification_service" {
  name      = "notification-service"
  namespace_id = "ns-4oyhwrcwro7zmhcu"
}

# Create ECS Service for Notification API
resource "aws_ecs_service" "notification_api_service" {
  name            = "notification-api-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.notification_api.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = data.aws_subnets.default.ids
    security_groups = [data.aws_security_group.default.id]
    assign_public_ip = true
  }
  service_registries {
    registry_arn = data.aws_service_discovery_service.notification_service.arn
    }
}

# Create ECS Service for Email Sender
resource "aws_ecs_service" "email_sender_service" {
  name            = "email-sender-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.email_sender.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = data.aws_subnets.default.ids
    security_groups = [data.aws_security_group.default.id]
    assign_public_ip = true
  }
  service_registries {
    registry_arn = data.aws_service_discovery_service.email_service.arn
    }
}
