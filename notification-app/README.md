# Notification API

The Notification API is a microservice designed to receive requests and queue messages into Amazon SQS for further processing. This service is typically used in conjunction with other microservices, like an email sender service, which processes the queued messages.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Environment Variables](#environment-variables)
- [Installation](#installation)
- [Running the Application](#running-the-application)
- [Docker Instructions](#docker-instructions)
- [Deployment](#deployment)
- [API Endpoints](#api-endpoints)
- [Health Check](#health-check)
- [License](#license)

## Prerequisites

Before you begin, ensure you have met the following requirements:

- You have installed [Node.js](https://nodejs.org/) (v14 or higher).
- You have an AWS account with permissions to access SQS services.
- You have configured your AWS credentials locally or using an IAM role when deployed.

## Environment Variables

This application uses environment variables for configuration. Create a `.env` file in the root directory and add the following:

 ## plaintext
AWS_REGION=<your-aws-region>
SQS_QUEUE_URL=<your-sqs-queue-url>
## Installation
To install the necessary dependencies, run:
  npm install
## Running the Application
To start the application locally, use the following command:
     npm start

## API Endpoints
Receives a notification message and queues it into Amazon SQS.
  /send-notification
  {
  "message": "Your notification message here"
}
## Health Check
The application exposes a /health endpoint that can be used to monitor the service's health. This endpoint returns a 200 OK status if the service is running properly.
  /hea