output "connect_string" {
  value = format("gcloud container clusters get-credentials %s --zone %s-%s --project %s", var.cluster_name, var.region, var.zone[0], var.project_id)
}