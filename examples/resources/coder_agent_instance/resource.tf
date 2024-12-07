resource "wirtual_agent" "dev" {
  os   = "linux"
  arch = "amd64"
  auth = "google-instance-identity"
}

resource "google_compute_instance" "dev" {
  zone = "us-central1-a"
}

resource "wirtual_agent_instance" "dev" {
  agent_id    = wirtual_agent.dev.id
  instance_id = google_compute_instance.dev.instance_id
}
