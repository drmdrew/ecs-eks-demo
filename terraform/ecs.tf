
resource "aws_ecs_cluster" "ecs" {
  name = "ecs-1"
}

resource "aws_cloudwatch_log_group" "ecs" {
  name = "ecs-1"
}

resource "aws_iam_role" "ecs" {
  name = "${var.environment}_ecs_instance_role"
  path = "/ecs/"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ecs" {
  name = "${var.environment}_ecs_instance_profile"
  role = "${aws_iam_role.ecs.name}"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_role" {
  role       = "${aws_iam_role.ecs.id}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_cloudwatch_role" {
  role       = "${aws_iam_role.ecs.id}"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

module "ecs" {
  source = "terraform-aws-modules/autoscaling/aws"

  name = "ecs"

  lc_name = "ecs"
  image_id             = "${data.aws_ami.amazon_linux_ecs.id}"
  instance_type        = "t2.small"
  security_groups      = ["${aws_security_group.ecs_allow_all.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.ecs.id}"
  user_data            = "${data.template_file.user_data.rendered}"

  asg_name                  = "ecs"
  vpc_zone_identifier       = "${module.vpc.private_subnets}"
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
    },
  ]
}

resource "aws_security_group" "ecs_allow_all" {
  name        = "ecs_allow_all"
  description = "Allow all inbound traffic"
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "65535"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
data "template_file" "user_data" {
  template = "${file("templates/user-data.sh")}"

  vars {
    cluster_name = "ecs-1"
  }
}
