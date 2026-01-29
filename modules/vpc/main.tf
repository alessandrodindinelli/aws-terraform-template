module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0.1"

  name = "${local.prefix}-vpc"
  cidr = var.vpc_cidr

  azs                  = local.azs
  private_subnets      = var.private_subnet_cidrs
  public_subnets       = var.public_subnet_cidrs
  private_subnet_names = ["${local.prefix}-pvt-a", "${local.prefix}-pvt-b"]
  public_subnet_names  = ["${local.prefix}-pub-a", "${local.prefix}-pub-b"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.common_tags
}
