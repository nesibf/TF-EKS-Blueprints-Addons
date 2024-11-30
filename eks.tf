module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.15"

  cluster_name                   = local.name
  cluster_version                = var.eks_cluster_version
  cluster_endpoint_public_access = true
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = compact([for subnet_id, cidr_block in zipmap(module.vpc.private_subnets, module.vpc.private_subnets_cidr_blocks) : substr(cidr_block, 0, 4) == "100." ? subnet_id : null])

  aws_auth_roles = [
    {
      rolearn  = module.eks_blueprints_addons.karpenter.node_iam_role_arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }
  ]

  eks_managed_node_groups = {
    core_node_group = {
      name             = "core-node-group"
      ami_type         = "AL2_x86_64"
      min_size         = 2
      max_size         = 8
      desired_size     = 2
      instance_types   = ["m5.xlarge"]
      capacity_type    = "SPOT"
      labels           = { WorkerType = "SPOT", NodeGroupType = "core" }
      tags             = merge(local.tags, { Name = "core-node-grp" })
    }
  }
}
