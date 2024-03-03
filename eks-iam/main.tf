data "aws_ssm_parameter" "oidc_provider_arn" {
  name  = "/eks/${var.cluster_name}/oidc_provider_arn"
}
module "reejig_app_irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "eks-${var.role_name}"
  role_policy_arns = var.role_policy_arns
  oidc_providers = {
    main = {
      provider_arn               = data.aws_ssm_parameter.oidc_provider_arn.value
      namespace_service_accounts = var.namespace_service_accounts
    }
  }
}
output "iam_role_arn" {
  value = module.reejig_app_irsa.iam_role_arn
}
