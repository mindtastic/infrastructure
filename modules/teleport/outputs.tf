output "teleport_public_ip" {
  value = data.kubernetes_service.teleport.spec.0.load_balancer_ip
}
