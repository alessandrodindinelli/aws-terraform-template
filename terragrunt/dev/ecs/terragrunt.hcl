include "root" {
  path = find_in_parent_folders()
}

dependency "common" {
  config_path = "${get_repo_root()}/terragrunt/dev/common"
}

dependency "vpc" {
  config_path = "${get_repo_root()}/terragrunt/dev/vpc"
}

terraform {
  source = "${get_repo_root()}/modules/ecs"
}

inputs = {
  region = dependency.common.outputs.region
  project = dependency.common.outputs.project
  environment = dependency.common.outputs.environment
  vpc_id = dependency.vpc.outputs.vpc_id
  vpc_cidr = dependency.vpc.outputs.vpc_cidr
  private_subnet_ids = dependency.vpc.outputs.private_subnet_ids
  public_subnet_ids = dependency.vpc.outputs.public_subnet_ids
  services = {
    service1 = {
      name = "service-1"
      dns_name = "service-1"
      container_port = 8080
      environment_variables = [
        {name = "ENV", value = "dev"}
      ]
      capacity_provider_strategy = "ALL_SPOT"
      autoscaling = {
        type         = "CPU"
        target       = "70"
        min_capacity = 0
        max_capacity = 3
      }
      iam = {
        managed_policies = ["arn:aws:iam::aws:policy/AmazonS3FullAccess"]
      }
      load_balancer = {
        rule = {
          "type" : "PATH"
          "values" : ["/service-1"]
        }
        healthcheck = {
          path = "/heath-check"
        }
      }
    }
    service2 = {
      name = "service-2"
      dns_name = "service-2"
      container_port = 9090
      environment_variables = [
        {name = "ENV", value = "dev"}
      ]
      capacity_provider_strategy = "ALL_SPOT"
      autoscaling = {
        type         = "CPU"
        target       = "70"
        min_capacity = 0
        max_capacity = 3
      }
      iam = {
        managed_policies = ["arn:aws:iam::aws:policy/AmazonS3FullAccess"]
      }
      load_balancer = {
        rule = {
          "type" : "PATH"
          "values" : ["/service-2"]
        }
        healthcheck = {
          path = "/heath-check"
        }
      }
    }
  }
  load_balancer = {
    listeners = {
      http = {
        port     = 80
        protocol = "HTTP"
      }
    }
  }
  global_iam = {
    managed_policies = ["arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]
  }
}
