locals {
  release_name = "linkerd"
}

resource "helm_release" "linkerd" {
  name             = local.release_name
  repository       = "https://helm.linkerd.io/stable"
  chart            = "linkerd2"
  version          = "2.11.2"
  create_namespace = true
  namespace        = "linkerd"
  max_history      = 3

  set {
    name  = "identityTrustAnchorsPEM"
    value = tls_self_signed_cert.root_certificate.cert_pem
  }
  set {
    name  = "identity.issuer.tls.crtPEM"
    value = tls_self_signed_cert.root_certificate.cert_pem
  }
  set {
    name  = "identity.issuer.tls.keyPEM"
    value = tls_private_key.root_private_key.private_key_pem
  }
}
