include "root" {
  path = find_in_parent_folders()
}

dependency "common" {
  config_path = "${get_repo_root()}/terragrunt/dev/common"
}

dependency "ecs" {
  config_path = "${get_repo_root()}/terragrunt/dev/ecs"
}

terraform {
  source = "${get_repo_root()}/modules/ecs-scheduler"
}

inputs = {
  region = dependency.common.outputs.region
  project = dependency.common.outputs.project
  environment = dependency.common.outputs.environment
  ecs_cluster = dependency.ecs.outputs.ecs_cluster
  ecs_services = ["service1", "service2"]
  desired_count = "0"
  crons_start = "0 5 ? * MON-FRI *"
  crons_stop = "0 19 ? * MON-FRI *"
}
