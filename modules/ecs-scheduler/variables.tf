variable "region" {
  description = "Name of the AWS region"
}

variable "project" {
  description = "Name of the project, for creating the prefix"
  type        = string
}

variable "environment" {
  description = "Name of the environment, for creating the prefix"
  type        = string
}

variable "ecs_cluster" {
  description = "Name of the ECS cluster to manage"
  type        = string
}

variable "ecs_services" {
  description = "Comma-separated list of ECS service names"
  type        = list(string)
}

variable "desired_count" {
  description = "Default desired count for ECS services"
  type        = string
}

variable "crons_start" {
  description = "Cron expression for the Start action of the ECS Services"
  type        = string
}

variable "crons_stop" {
  description = "Cron expression for the Stop action of the ECS Services"
  type        = string
}
