output "connect" {
  value = "gcloud container clusters get-credentials ${var.cluster_name} --zone ${var.location} --project ${var.project_id}"
}