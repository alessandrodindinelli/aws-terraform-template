terraform {
  required_version = ">= 1.9.8"
  required_providers {
    aws = "~> 6.0"
  }
}

provider "aws" {
  region = var.region
}
