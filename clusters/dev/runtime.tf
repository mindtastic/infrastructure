module "teleport" {
  source = "../../modules/teleport-agent"

  teleport_cluster_name  = local.cluster_name
  teleport_proxy_address = var.runtime_teleport_proxy_address
  teleport_auth_token    = var.runtime_teleport_auth_token

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary_nodes
  ]
}
