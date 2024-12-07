data "wirtual_workspace" "me" {}

resource "wirtual_agent" "dev" {
  os   = "linux"
  arch = "amd64"
  dir  = "/workspace"
}

resource "wirtual_env" "welcome_message" {
  agent_id = wirtual_agent.dev.id
  name     = "WELCOME_MESSAGE"
  value    = "Welcome to your Wirtual workspace!"
}

resource "wirtual_env" "internal_api_url" {
  agent_id = wirtual_agent.dev.id
  name     = "INTERNAL_API_URL"
  value    = "https://api.internal.company.com/v1"
}