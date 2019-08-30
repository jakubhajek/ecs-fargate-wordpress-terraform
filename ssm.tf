resource "aws_ssm_parameter" "database-master-password" {
  name        = "/${var.environment}/database/password/master"
  description = "Datbase password"
  type        = "SecureString"
  value       = "${var.database_master_password}"

  tags = {
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "database-host" {
  name        = "/${var.environment}/database/host"
  description = "Database host"
  type        = "SecureString"
  value       = "${var.database_host}"

  tags = {
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "database-user" {
  name        = "/${var.environment}/database/user"
  description = "Datbase user"
  type        = "SecureString"
  value       = "${var.database_user}"

  tags = {
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "database-name" {
  name        = "/${var.environment}/database/name"
  description = "Datbase name"
  type        = "SecureString"
  value       = "${var.database_name}"

  tags = {
    environment = "${var.environment}"
  }
}
