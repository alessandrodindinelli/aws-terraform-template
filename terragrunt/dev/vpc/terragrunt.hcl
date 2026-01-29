include "root" {
  path = find_in_parent_folders()
}

dependency "common" {
  config_path = "${get_repo_root()}/terragrunt/dev/common"
}

terraform {
  source = "${get_repo_root()}/modules/vpc"
}

inputs = {
  region = dependency.common.outputs.region
  project = dependency.common.outputs.project
  environment = dependency.common.outputs.environment
  vpc_cidr = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
}
