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

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDRs to use for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDRs to use for private subnets"
  type        = list(string)
}
