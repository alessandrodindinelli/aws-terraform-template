locals {
  prefix = "${var.environment}-${var.project}"
  azs    = ["${var.region}a", "${var.region}b"]
  common_tags = {
    managedBy   = "terraform"
    environment = var.environment
  }
}
