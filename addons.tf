eks_addons = {
  amazon-cloudwatch-observability = {
    preserve                 = true
    service_account_role_arn = aws_iam_role.cloudwatch_observability_role.arn
  }
}
