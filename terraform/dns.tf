
resource "aws_route53_zone" "ecs-eks-demo" {
  name = "ecs-eks-demo.dreamdrew.ca"

  tags {
    Environment = "dev"
  }
}

