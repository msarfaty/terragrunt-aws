locals {
  env = yamldecode(file("../env.yaml"))
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id          = "vpc-1234556abcdef"
    public_subnets  = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
    private_subnets = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
  }
}

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=v20.35.0"
}

inputs = {
  # it hurts me, but for now will use auto-mode
  cluster_name    = "aws-eks-${local.env.common.name}-001"
  cluster_version = "1.31"

  cluster_endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnets

  tags = local.env.common.tags
}