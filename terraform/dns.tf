
resource "aws_route53_zone" "ecs-eks-demo" {
  name = "${var.domain_name}"

  tags {
    Environment = "dev"
  }
}

