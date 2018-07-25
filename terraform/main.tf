module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ecs-eks-demo"
  cidr = "${var.vpc_cidr}" // 10.66.0.0/16

  azs             = ["us-east-1b", "us-east-1c", "us-east-1d"]
  private_subnets = ["10.66.1.0/24", "10.66.2.0/24", "10.66.3.0/24"]
  public_subnets  = ["10.66.101.0/24", "10.66.102.0/24", "10.66.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Environment = "dev"
    Owner = "drmdrew"
  }
}
