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

  set {
    name  = "installNamespace"
    value = false
  }
  set_sensitive {
    name  = "identityTrustAnchorsPEM"
    value = tls_self_signed_cert.root_certificate.cert_pem
  }
  set_sensitive {
    name  = "identity.issuer.tls.crtPEM"
    value = tls_locally_signed_cert.intermediate_ca.cert_pem
  }
  set_sensitive {
    name  = "identity.issuer.tls.keyPEM"
    value = tls_private_key.intermediate_ca.private_key_pem
  }
}
