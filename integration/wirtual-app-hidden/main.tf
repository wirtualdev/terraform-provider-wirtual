terraform {
  required_providers {
    wirtual = {
      source = "wirtual/wirtual"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

data "wirtual_workspace" "me" {}

resource "wirtual_agent" "dev" {
  os   = "linux"
  arch = "amd64"
  dir  = "/workspace"
}

resource "wirtual_app" "hidden" {
  agent_id = wirtual_agent.dev.id
  slug     = "hidden"
  share    = "owner"
  hidden   = true
}

resource "wirtual_app" "visible" {
  agent_id = wirtual_agent.dev.id
  slug     = "visible"
  share    = "owner"
  hidden   = false
}

resource "wirtual_app" "defaulted" {
  agent_id = wirtual_agent.dev.id
  slug     = "defaulted"
  share    = "owner"
}

locals {
  # NOTE: these must all be strings in the output
  output = {
    "wirtual_app.hidden.hidden"    = tostring(wirtual_app.hidden.hidden)
    "wirtual_app.visible.hidden"   = tostring(wirtual_app.visible.hidden)
    "wirtual_app.defaulted.hidden" = tostring(wirtual_app.defaulted.hidden)
  }
}

variable "output_path" {
  type = string
}

resource "local_file" "output" {
  filename = var.output_path
  content  = jsonencode(local.output)
}

output "output" {
  value     = local.output
  sensitive = true
}

