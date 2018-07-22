
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
          "hostPort": $${container_port},
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
    log_group_name   = "${var.log_group_name}"
    log_group_region = "${var.log_group_region}"
    log_group_prefix = "${var.log_group_prefix}"
    network_mode     = "${var.network_mode}"
  }
}
