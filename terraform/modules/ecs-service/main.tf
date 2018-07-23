
resource "aws_ecs_task_definition" "task" {
  family                = "${var.container_name}"
  container_definitions = "${data.template_file.definition.rendered}"
  network_mode = "${var.network_mode}"
  cpu = "${var.container_cpu}"
  memory = "${var.container_memory}"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = "${aws_iam_role.cloudwatch.id}"
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "cloudwatch"
  role = "${aws_iam_role.cloudwatch.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogStreams",
        "logs:PutSubscriptionFilter",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "cloudwatch" {
  name = "cloudwatch"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "template_file" "definition" {
  template = <<EOF
  [
    {
      "essential": true,
      "memoryReservation": null,
      "image": "$${container_image}",
      "name": "$${container_name}",
      "portMappings": [
        {
          "hostPort": $${host_port},
          "protocol": "tcp",
          "containerPort": $${container_port}
        }
      ],
      "command": [$${container_command}],
      "environment": [],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "$${log_group_name}",
          "awslogs-region": "$${log_group_region}",
          "awslogs-stream-prefix": "$${log_group_prefix}"
        }
      }
    }
  ]

  EOF
  vars {
    container_image  = "${var.container_image}"
    container_name   = "${var.container_name}"
    container_port   = "${var.container_port}"
    container_memory = "${var.container_memory}"
    container_cpu    = "${var.container_cpu}"
    container_command = "${join(",", formatlist("\"%s\"", var.container_command))}"
    host_port   = "${var.host_port}"
    log_group_name   = "${var.log_group_name}"
    log_group_region = "${var.log_group_region}"
    log_group_prefix = "${var.log_group_prefix}"
    network_mode     = "${var.network_mode}"
  }
}

resource "aws_ecs_service" "service" {
  name            = "${var.container_name}"
  cluster         = "${var.cluster_id}"
  task_definition = "${aws_ecs_task_definition.task.arn}"
  desired_count   = 1
  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = "${aws_lb_target_group.service.arn}"
    container_name   = "${var.container_name}"
    container_port   = "${var.container_port}"
  }

  network_configuration {
    subnets = ["${var.subnet_ids}"]
    security_groups = ["${aws_security_group.allow_all.id}"]
  }
}

resource "aws_lb" "alb" {
  name               = "${var.container_name}"
  internal           = "${var.internal}"
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.allow_all.id}"]
  subnets            = ["${var.alb_subnet_ids}"]

  enable_deletion_protection = true
}

resource "aws_lb_listener" "service" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.service.arn}"
    type             = "forward"
  }
}

resource "aws_lb_target_group" "service" {
  name     = "${var.container_name}"
  port     = "${var.host_port}" 
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  target_type = "ip"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "${var.host_port}"
    to_port     = "${var.host_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}