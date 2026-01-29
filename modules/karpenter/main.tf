module "iam" {
  source = "../iam"

  cluster_name      = var.cluster_name
  oidc_provider_arn = var.oidc_provider_arn
}

resource "helm_release" "karpenter" {
  name             = "karpenter"
  namespace        = "karpenter"
  create_namespace = true

  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  version    = "0.35.0"

  # Give Karpenter time to come up on the bootstrap node
  timeout = 600

  values = [
    yamlencode({
      replicas = 1
      # Allow Karpenter to run on the bootstrap node group
      tolerations = [
        {
          key      = "bootstrap"
          operator = "Exists"
          effect   = "NoSchedule"
        }
      ]

      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = module.iam.karpenter_role_arn
        }
      }

      settings = {
        clusterName     = var.cluster_name
        clusterEndpoint = var.cluster_endpoint
        interruptionHandling = false
      }
    })
  ]
}


