module "eks" {
  source = "../../modules/eks"

  environment        = var.environment
  vpc_id             = data.aws_vpc.selected.id
  private_subnets    = data.aws_subnets.private.ids
  office_sg_id       = data.aws_security_group.office_ips.id
  ssh_key_name       = var.ssh_key_name
  terraform_role_arn = var.terraform_role_arn
}


module "karpenter" {
  source = "../../modules/karpenter"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  oidc_provider_arn = module.eks.oidc_provider_arn

}


