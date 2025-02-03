output "eks_cluster_name" {
  description = "Name of the EKS Cluster"
  value       = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  description = "EKS Cluster endpoint"
  value       = module.eks.cluster_endpoint
}
