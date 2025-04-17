locals {
  env = yamldecode(file("../env.yaml"))
}

include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v5.19.0"
}

inputs = {
  name = "${local.env.common.name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = local.env.common.availability_zones
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # nat gateway settings
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_vpn_gateway = false

  tags = local.env.common.tags
}
