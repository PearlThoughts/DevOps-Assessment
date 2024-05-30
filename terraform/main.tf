module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "notification-service-vpc"
  cidr   = "10.0.0.0/16"
  azs    = ["us-west-2a", "us-west-2b", "us-west-2c"]
  subnets = {
    public = ["10.0.1.0/24", "10.0.2.0/24"]
    private = ["10.0.3.0/24", "10.0.4.0/24"]
  }
}
