resource "tls_private_key" "root_private_key" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_private_key" "intermediate_ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

resource "tls_cert_request" "intermediate_ca" {
  key_algorithm   = tls_private_key.intermediate_ca.algorithm
  private_key_pem = tls_private_key.intermediate_ca.private_key_pem

  subject {
    common_name  = "root.linkerd.cluster.local"
    organization = "mindtastic"
  }
  uris = ["root.linkerd.cluster.local"]
}

resource "tls_locally_signed_cert" "intermediate_ca" {
  cert_request_pem   = tls_cert_request.intermediate_ca.cert_request_pem
  ca_key_algorithm   = tls_private_key.root_private_key.algorithm
  ca_private_key_pem = tls_private_key.root_private_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.root_certificate.cert_pem

  validity_period_hours = 8760
  is_ca_certificate     = true
  allowed_uses          = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
  ]
}

resource "tls_self_signed_cert" "root_certificate" {
  private_key_pem = tls_private_key.root_private_key.private_key_pem

  subject {
    common_name  = "root.linkerd.cluster.local"
    organization = "mindtastic"
  }

  validity_period_hours = 8760
  is_ca_certificate     = true

  allowed_uses = [
    "cert_signing",
    "key_encipherment",
    "digital_signature",
  ]
}
