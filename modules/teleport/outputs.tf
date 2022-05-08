output "teleport_public_ip" {
  value = data.kubernetes_service.teleport.spec.load_balancer_ip
}
