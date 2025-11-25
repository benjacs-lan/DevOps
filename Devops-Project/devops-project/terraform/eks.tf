
# Modulo EKS
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project_name}-cluster"
  cluster_version = "1.29"

  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Grupo de nodos gestionados por EKS
  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }

  # Otorga permisos de administrador al creador del clúster (útil para pruebas)
  enable_cluster_creator_admin_permissions = true

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
