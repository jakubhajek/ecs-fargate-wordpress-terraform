variable "aws_region" {
  default = "us-east-1"
}

variable "environment" {
  default = "production"
}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "2"
}

variable "cf-webapp-aliases" {
  description = "List of CloudFront domain aliases."
  type        = "list"

  default = [
    "domain.org",
    "www.domain.org",
  ]
}

variable "webapp_image" {
  description = "Docker image to run in the ECS cluster"
  default     = ""
}

variable "webapp_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 80
}

variable "webapp_count" {
  description = "Number of docker containers to run"
  default     = 2
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "database_host" {}

variable "database_user" {}

variable "database_master_password" {}

variable "database_name" {}

variable "cookies_whitelisted_names" {
  description = "List of cookies to be whitelisted."
  type        = "list"

  default = [
    "comment_author_*",
    "comment_author_email_*",
    "comment_author_url_*",
    "wordpress_*",
    "wordpress_logged_in_*",
    "wordpress_test_cookie",
    "wp-settings-*",
  ]
}

variable "min_ttl" {
  description = "The minimum time you want objects to stay in CloudFront"
  default     = 0
}

variable "default_ttl" {
  description = "The default amount of time an object is ina CloudFront cache before it sends another request in absence of Cache-Control"
  default     = 300
}

variable "max_ttl" {
  description = "The maxium amount of seconds you want CloudFront to cache the object, before feching it from the origin"
  default     = 31536000
}

variable "evaluation_periods" {
  default = "4"
}

variable "period_down" {
  default = "120"
}

variable "period_up" {
  default = "60"
}

variable "threshold_up" {
  default = "75"
}

variable "threshold_down" {
  default = "25"
}

variable "statistic" {
  default = "Average"
}

variable "min_capacity" {
  default = "1"
}

variable "max_capacity" {
  default = "4"
}

variable "lowerbound" {
  default = "0"
}

variable "upperbound" {
  default = "0"
}

variable "scale_up_adjustment" {
  default = "1"
}

variable "scale_down_adjustment" {
  default = "-1"
}

variable "datapoints_to_alarm_up" {
  default = "4"
}

variable "datapoints_to_alarm_down" {
  default = "4"
}
