resource "tls_private_key" "root_private_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_self_signed_cert" "root_certificate" {
  private_key_pem = tls_private_key.root_private_key.private_key_pem

  subject {
    common_name  = "root.linkerd.cluster.local"
    organization = "mindtastic"
  }

  validity_period_hours = 8760

  allowed_uses = [
    "any_extended",
  ]
}
