resource "aws_ecr_repository" "ecs-eks-demo" {
  name = "ecs-eks-demo"
}

resource "aws_ecr_repository" "nginx" {
  name = "nginx"
}

