### ECS
resource "aws_ecs_cluster" "main" {
  name = "asa-ecs-cluster"
}

data "template_file" "webapp" {
  template = "${file("task_definitions/service.json")}"

  vars {
    db_host = "${aws_ssm_parameter.database-host.value}"
    db_user = "${aws_ssm_parameter.database-user.value}"
    db_pass = "${aws_ssm_parameter.database-master-password.value}"
    db_name = "${aws_ssm_parameter.database-name.value}"
  }
}

resource "aws_ecs_task_definition" "webapp" {
  family                   = "webapp"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.fargate_cpu}"
  memory                   = "${var.fargate_memory}"
  task_role_arn            = "${aws_iam_role.ecs_task_assume_role.arn}"
  execution_role_arn       = "${aws_iam_role.ecs_task_execution_role.arn}"

  container_definitions = "${data.template_file.webapp.rendered}"
}

# log group
resource "aws_cloudwatch_log_group" "webapp" {
  name = "awslogs-wordpress"

  tags = {
    Environment = "production"
    Application = "wordpress"
  }
}

resource "aws_ecs_service" "webapp" {
  name            = "asa-webapp"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.webapp.arn}"
  desired_count   = "${var.webapp_count}"
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = ["${aws_security_group.ecs_tasks.id}"]
    subnets         = ["${aws_subnet.private.*.id}"]
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.webapp.id}"
    container_name   = "webapp"
    container_port   = "${var.webapp_port}"
  }

  depends_on = [
    "aws_alb_listener.http_webapp",
  ]
}

# Traffic to the ECS Cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "tf-ecs-tasks"
  description = "allow inbound access from the ALB only"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    protocol        = "tcp"
    from_port       = "${var.webapp_port}"
    to_port         = "${var.webapp_port}"
    security_groups = ["${aws_security_group.lb_http.id}"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
