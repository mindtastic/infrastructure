output "teleport_public_ip" {
  value = data.kubernetes_service.teleport.status.0.load_balancer.0.ingress.0.ip
}
