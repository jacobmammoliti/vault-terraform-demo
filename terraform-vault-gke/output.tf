output "connect_string" {
  value = "gcloud container clusters get-credentials ${var.cluster_name} --zone ${var.region}-${var.zone[0]} --project ${var.project}"
}