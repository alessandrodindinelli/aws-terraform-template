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

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "The IDs of the Private Subnets"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "The IDs of the Public Subnets"
  type        = list(string)
}

variable "services" {
  description = "Map of services to deploy"
  type = map(object({
    name                       = string
    dns_name                   = string
    cpu                        = optional(number, 512)
    memory                     = optional(number, 1024)
    container_port             = optional(number, 8000)
    environment_variables      = optional(list(object({ name = string, value = string })), [])
    capacity_provider_strategy = optional(string, "ALL_ONDEMAND")
    autoscaling = optional(object({
      type               = string
      target             = number
      min_capacity       = number
      max_capacity       = number
      scale_out_cooldown = optional(number, 200)
      scale_in_cooldown  = optional(number, 200)
    }))
    iam = optional(object({
      managed_policies = optional(list(string), [])
    }), null)
    load_balancer = optional(object({
      rule = object({
        type   = string
        values = set(string)
      })
      healthcheck = object({
        path                = string
        healthy_threshold   = optional(number, 2)
        unhealthy_threshold = optional(number, 10)
      })
    }))
  }))
}

variable "global_iam" {
  description = "Global IAM policies to apply to all services"
  type = object({
    managed_policies = optional(list(string), [])
  })
  default = {
    managed_policies = []
  }
}

variable "load_balancer" {
  description = "Load balancer configuration"
  type = object({
    listeners = map(object({
      port     = number
      protocol = string
    }))
  })
  default = null
}
