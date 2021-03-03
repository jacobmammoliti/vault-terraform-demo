resource "kubernetes_namespace" "logging" {
  depends_on = [google_container_cluster.vault]

  metadata {
    name = "logging"
  }
}

resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  namespace  = kubernetes_namespace.logging.metadata[0].name
  chart      = "elasticsearch"
  repository = "https://helm.elastic.co"
}

resource "helm_release" "filebeat" {
  name       = "filebeat"
  namespace  = kubernetes_namespace.logging.metadata[0].name
  chart      = "filebeat"
  repository = "https://helm.elastic.co"
}

resource "helm_release" "kibana" {
  name       = "kibana"
  namespace  = kubernetes_namespace.logging.metadata[0].name
  chart      = "kibana"
  repository = "https://helm.elastic.co"
}