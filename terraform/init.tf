terraform {
  backend "s3" {
    key    = "ecs-eks-demo/terraform"
    region = "us-east-1"
    profile = "default"
  }
}
