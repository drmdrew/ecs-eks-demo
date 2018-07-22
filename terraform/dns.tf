resource "aws_route53_zone" "main" {
  name = "dreamdrew.ca"
}

resource "aws_route53_zone" "ecs-eks-demo" {
  name = "ecs-eks-demo.dreamdrew.ca"

  tags {
    Environment = "dev"
  }
}

resource "aws_route53_record" "ecs-eks-demo-ns" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "ecs-eks-demo.dreamdrew.ca"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.ecs-eks-demo.name_servers.0}",
    "${aws_route53_zone.ecs-eks-demo.name_servers.1}",
    "${aws_route53_zone.ecs-eks-demo.name_servers.2}",
    "${aws_route53_zone.ecs-eks-demo.name_servers.3}",
  ]
}
