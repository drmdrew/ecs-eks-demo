terraform {
  backend "s3" {
    bucket = "drmdrew.ca-ecs-eks-demo"
    key    = "ecs-eks-demo/terraform"
    region = "us-east-1"
    profile = "default"
  }
}
