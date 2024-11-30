module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name                 = local.name
  cidr                 = var.vpc_cidr
  azs                  = local.azs
  secondary_cidr_blocks = var.secondary_cidr_blocks
  private_subnets      = concat(local.private_subnets, local.secondary_ip_range_private_subnets)
  public_subnets       = local.public_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  public_subnet_tags   = {"kubernetes.io/role/elb" = 1}
  private_subnet_tags  = {
    "kubernetes.io/role/internal-elb" = 1
    "karpenter.sh/discovery" = local.name
  }
  tags = local.tags
}
