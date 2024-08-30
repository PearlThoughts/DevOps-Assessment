provider "aws" {
  region = "ap-south-1"  # Update with your AWS region
}

resource "aws_s3_bucket" "saadterraform" {
  bucket = "saadterraform"
  
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT", "DELETE"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
