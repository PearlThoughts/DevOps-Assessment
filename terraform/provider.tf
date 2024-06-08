terraform {
  cloud {
    organization = "sky-1704"
    workspaces {
      name = "ecs-fargate-notification"
    }
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
  # profile = var.aws_profile

}
