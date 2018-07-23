
module "echo-service" {
  source = "./modules/ecs-service"

  internal = "false"
  vpc_id = "${module.vpc.vpc_id}"
  cluster_id = "${aws_ecs_cluster.ecs.id}"
  subnet_ids = "${module.vpc.private_subnets}"
  alb_subnet_ids = "${module.vpc.public_subnets}"
  container_image = "hashicorp/http-echo:latest"
  container_name = "http-echo"
  container_port = "5678"
  host_port = "5678"
  container_command = ["-text", "Hello"]

  log_group_name = "${aws_cloudwatch_log_group.ecs.name}"
  log_group_region = "${var.region}"
  log_group_prefix = "http-echo"
}
