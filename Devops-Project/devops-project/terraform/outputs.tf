# Salidas

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane" # Endpoint para el controlador de EKS
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane" # Grupo de seguridad del controlador de EKS
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region" # Region de AWS
  value       = var.location
}

output "cluster_name" {
  description = "Kubernetes Cluster " # Nombre del cluster de Kubernetes
  value       = module.eks.cluster_name
}
