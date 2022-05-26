output "vpc_self_link" {
  description = "Self Link of VPC for this Cluster"
  value       = google_compute_network.vpc_network.self_link

  depends_on = [
    google_compute_network.vpc_network
  ]
}
