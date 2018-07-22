
module "echo-service" {
  source = "./modules/ecs-service"

  container_image = "hashicorp/http-echo:latest"
  container_name = "http-echo"
  container_port = "80"
  container_command = ["-text", "Hello"]

  log_group_name = "${aws_cloudwatch_log_group.ecs.name}"
  log_group_region = "${var.region}"
  log_group_prefix = "http-echo"
}
