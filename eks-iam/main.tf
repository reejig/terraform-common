resource "aws_iam_policy" "policy" {
  name        = var.role_name
  description = "EKS policy for ${var.role_name}"
  policy      = var.policy
}
data "aws_ssm_parameter" "oidc_provider_arn" {
  name  = "/eks/${var.cluster_name}/oidc_provider_arn"
}
module "reejig_app_irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "eks-${var.role_name}"
  role_policy_arns = {
    policy = aws_iam_policy.policy.arn
  }
  oidc_providers = {
    main = {
      provider_arn               = data.aws_ssm_parameter.oidc_provider_arn[0].value
      namespace_service_accounts = var.namespace_service_accounts
    }
  }
}