data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_execution" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_assume_role" {
  name = "ecs_task_assume"

  assume_role_policy = "${data.aws_iam_policy_document.ecs_task_assume.json}"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecs_task_execution_role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_task_execution.json}"
}

resource "aws_iam_policy" "ecs_ssm_read" {
  name = "ssm_read"

  policy = "${file("policies/ssm_read.json")}"
}

resource "aws_iam_role_policy" "ecs_task_execution" {
  name   = "ecs_task_execution"
  role   = "${aws_iam_role.ecs_task_execution_role.id}"
  policy = "${file("policies/ecs_task_execution.json")}"
}

resource "aws_iam_role_policy" "ecs_task_assume" {
  name   = "ecs_task_assume"
  role   = "${aws_iam_role.ecs_task_assume_role.id}"
  policy = "${file("policies/ecs_task_assume.json")}"
}
