output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_ca_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "ecr_url" {
  value = aws_ecr_repository.app.repository_url
}
