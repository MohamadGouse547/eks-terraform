module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.environment}-eks"
  cluster_version = "1.29"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false

  enable_irsa = true

  eks_managed_node_groups = {}

  node_security_group_additional_rules = {
    office_ssh = {
      protocol  = "tcp"
      from_port = 22
      to_port   = 22
      type      = "ingress"
      source_security_group_id = var.office_sg_id
    }
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

