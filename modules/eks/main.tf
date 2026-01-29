module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 20.0"

  cluster_name    = "${var.environment}-eks"
  cluster_version = "1.29"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  enable_irsa = true

  eks_managed_node_groups = {
    bootstrap = {
      name           = "bootstrap-ng"
      instance_types = ["t3.small"]
      min_size       = 1
      max_size       = 1
      desired_size   = 1

      labels = {
        role = "bootstrap"
      }

      taints = {
        bootstrap = {
          key    = "bootstrap"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      }
    }
  }

  node_security_group_additional_rules = {
    office_ssh = {
      protocol                 = "tcp"
      from_port                = 22
      to_port                  = 22
      type                     = "ingress"
      source_security_group_id = var.office_sg_id
    }
    dns_udp = {
      protocol    = "udp"
      from_port   = 53
      to_port     = 53
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }

    dns_tcp = {
      protocol    = "tcp"
      from_port   = 53
      to_port     = 53
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }

    https = {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  access_entries = {
    terraform = {
      principal_arn = var.terraform_role_arn
      type          = "STANDARD"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

