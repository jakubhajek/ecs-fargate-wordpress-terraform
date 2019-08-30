variable "https_port" {
  default = "443"
}

variable "certificate_arn" {
  default = "arn:aws:acm:us-east-1:559599047830:certificate/e827fe10-ee1f-4024-ad54-75139b3b4d66"
}

resource "aws_alb_listener" "https_webapp" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = "${var.https_port}"
  protocol          = "HTTPS"
  certificate_arn   = "${var.certificate_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.webapp.id}"
    type             = "forward"
  }
}

resource "aws_security_group" "ingress_lb_https" {
  name        = "tf-ecs-alb-https"
  description = "controls access to the ALB"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
}
