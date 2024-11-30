enable_karpenter                  = true
karpenter_enable_spot_termination = true
karpenter_node = {
  iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}
karpenter = {
  chart_version       = "0.37.0"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
}
