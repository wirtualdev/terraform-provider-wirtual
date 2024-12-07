provider "wirtual" {}

data "wirtual_workspace" "me" {}

data "wirtual_workspace_owner" "me" {}

resource "wirtual_agent" "dev" {
  arch = "amd64"
  os   = "linux"
  dir  = local.repo_dir
  env = {
    OIDC_TOKEN : data.wirtual_workspace_owner.me.oidc_access_token,
  }
}

# Add git credentials from wirtual_workspace_owner
resource "wirtual_env" "git_author_name" {
  agent_id = wirtual_agent.agent_id
  name     = "GIT_AUTHOR_NAME"
  value    = coalesce(data.wirtual_workspace_owner.me.full_name, data.wirtual_workspace_owner.me.name)
}

resource "wirtual_env" "git_author_email" {
  agent_id = var.agent_id
  name     = "GIT_AUTHOR_EMAIL"
  value    = data.wirtual_workspace_owner.me.email
  count    = data.wirtual_workspace_owner.me.email != "" ? 1 : 0
}