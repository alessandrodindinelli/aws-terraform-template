include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "${get_repo_root()}/modules/common"
}

inputs = {
  region = "region-name"
  project = "project-name"
  environment = "dev"
}
