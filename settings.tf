variable "region" {
  default = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "cometari-tf-labs"
    key    = "terraform/tfstate/labs/asa"
    region = "us-east-1"
  }
}

provider "aws" {
  region  = "us-east-1"
  version = "1.57.0"
}
