resource "aws_ecr_repository" "my_repository" {
    name = "my_repository"
}

output "ECR_REPO_URL" {
  value = aws_ecr_repository.my_repository.repository_url
}

resource "null_resource" "createimage" {
    provisioner "local-exec" {
        command = "./ci-cd.sh"
    }
    depends_on = [aws_ecr_repository.my_repository]
  
}
