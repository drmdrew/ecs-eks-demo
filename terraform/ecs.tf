
resource "aws_ecs_cluster" "ecs" {
  name = "ecs-1"
}

resource "aws_cloudwatch_log_group" "ecs" {
  name = "ecs-1"
}
