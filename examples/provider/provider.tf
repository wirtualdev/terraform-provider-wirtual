terraform {
  required_providers {
    wirtual = {
      source = "wirtual/wirtual"
    }
  }
}

provider "google" {
  region = "us-central1"
}

data "wirtual_workspace" "me" {}

resource "wirtual_agent" "dev" {
  arch = "amd64"
  os   = "linux"
  auth = "google-instance-identity"
}

data "google_compute_default_service_account" "default" {}

resource "google_compute_instance" "dev" {
  zone         = "us-central1-a"
  count        = data.wirtual_workspace.me.start_count
  name         = "wirtual-${data.wirtual_workspace.me.owner}-${data.wirtual_workspace.me.name}"
  machine_type = "e2-medium"
  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  service_account {
    email  = data.google_compute_default_service_account.default.email
    scopes = ["cloud-platform"]
  }
  metadata_startup_script = wirtual_agent.dev.init_script
}
