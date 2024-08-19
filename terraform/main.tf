terraform {
  backend "s3" {
    bucket = "devops-assessment-chirag-terraform"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}
