variable "region" {
  description = "Name of the AWS region to deploy to"
  type        = string
}

variable "project" {
  description = "Name of the project, for creating the prefix"
  type        = string
}

variable "environment" {
  description = "Name of the environment, for creating the prefix"
  type        = string
}
