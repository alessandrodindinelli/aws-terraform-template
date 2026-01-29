locals {
  prefix = "${var.environment}-${var.project}"
  common_tags = {
    managedBy   = "terraform"
    environment = var.environment
  }
}
