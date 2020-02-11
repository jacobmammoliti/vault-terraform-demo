resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
}

resource "kubernetes_namespace" "consul" {
  metadata {
    name = "consul"
  }
}

resource "helm_release" "consul" {
  name      = "consul"
  chart     = "consul-helm"
  namespace = kubernetes_namespace.consul.metadata.0.name

  values = [
    templatefile("consul/values.tmpl", { replicas = var.initial_node_count })
  ]
}

resource "helm_release" "vault" {
  depends_on = [helm_release.consul]

  name      = "vault"
  chart     = "vault-helm"
  namespace = kubernetes_namespace.vault.metadata.0.name

  values = [
    templatefile("vault/values.tmpl", { replicas = var.initial_node_count })
  ]
}

data "kubernetes_service" "vault_svc" {
  depends_on = [
    helm_release.vault
  ]

  metadata {
    namespace = "vault"
    name      = "vault-ui"
  }
}

resource "google_dns_record_set" "vault" {
  name     = "${var.dns_name}."
  type     = "A"
  ttl      = 300

  managed_zone = var.dns_managed_zone
  project      = var.project
  rrdatas      = [data.kubernetes_service.vault_svc.load_balancer_ingress.0.ip]
}

resource "kubernetes_secret" "vault_tls" {
  metadata {
    name = "tls"
    namespace = "vault"
  }

  data = {
    "tls_crt" = file("certs/tls.crt"),
    "tls_key" = file("certs/tls.key")
  }
}