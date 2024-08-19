pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REGISTRY = 'YOUR_AWS_ACCOUNT_ID.dkr.ecr.${AWS_REGION}.amazonaws.com'
        ECR_REPO_API = "${ECR_REGISTRY}/notification-api"
        ECR_REPO_SENDER = "${ECR_REGISTRY}/email-sender"
        IMAGE_TAG = "${env.BUILD_ID}"
        TF_DIR = 'infra' // Directory where Terraform configuration is located
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/PearlThoughts/DevOps-Assessment.git'
            }
        }

        stage('Setup Docker') {
            steps {
                script {
                    docker.withRegistry("https://${ECR_REGISTRY}", 'ecr:YOUR_ECR_LOGIN_CREDENTIALS') {
                        echo 'Logged in to ECR'
                    }
                }
            }
        }

        stage('Build Docker Images') {
            parallel {
                stage('Build Notification API Image') {
                    steps {
                        script {
                            docker.build("${ECR_REPO_API}:${IMAGE_TAG}", 'path/to/Dockerfile/api')
                        }
                    }
                }
                stage('Build Email Sender Image') {
                    steps {
                        script {
                            docker.build("${ECR_REPO_SENDER}:${IMAGE_TAG}", 'path/to/Dockerfile/sender')
                        }
                    }
                }
            }
        }

        stage('Push Docker Images') {
            parallel {
                stage('Push Notification API Image') {
                    steps {
                        script {
                            docker.image("${ECR_REPO_API}:${IMAGE_TAG}").push()
                        }
                    }
                }
                stage('Push Email Sender Image') {
                    steps {
                        script {
                            docker.image("${ECR_REPO_SENDER}:${IMAGE_TAG}").push()
                        }
                    }
                }
            }
        }

        stage('Provision Infrastructure with Terraform') {
            steps {
                script {
                    sh """
                    cd ${TF_DIR}
                    terraform init
                    terraform apply -auto-approve -var 'api_image=${ECR_REPO_API}:${IMAGE_TAG}' -var 'sender_image=${ECR_REPO_SENDER}:${IMAGE_TAG}'
                    """
                }
            }
        }

        stage('Deploy Services to ECS Fargate') {
            steps {
                script {
                    // Assuming Terraform takes care of ECS Fargate deployment
                    echo 'Services deployed to ECS Fargate'
                }
            }
        }

        stage('Run Tests and Verifications') {
            steps {
                script {
                    // Implement your testing and verification steps here
                    echo 'Running tests and verifications...'
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
