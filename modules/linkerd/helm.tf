locals {
  release_name = "linkerd"
}

resource "helm_release" "linkerd" {
  name             = local.release_name
  repository       = "https://helm.linkerd.io/stable"
  chart            = "linkerd2"
  version          = "2.11.2"
  create_namespace = true # The creates the namespace with some annotations.
  namespace        = "linkerd"
  max_history      = 3

  set_sensitive {
    name  = "identityTrustAnchorsPEM"
    value = tls_self_signed_cert.root_certificate.cert_pem
  }
  set_sensitive {
    name  = "identity.issuer.tls.crtPEM"
    value = tls_self_signed_cert.root_certificate.cert_pem
  }
  set_sensitive {
    name  = "identity.issuer.tls.keyPEM"
    value = tls_private_key.root_private_key.private_key_pem
  }
}
