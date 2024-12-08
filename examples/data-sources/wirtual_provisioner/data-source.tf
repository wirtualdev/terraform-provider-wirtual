provider "wirtual" {}

data "wirtual_provisioner" "dev" {}

data "wirtual_workspace" "dev" {}

resource "wirtual_agent" "main" {
  arch = data.wirtual_provisioner.dev.arch
  os   = data.wirtual_provisioner.dev.os
  dir  = "/workspace"
  display_apps {
    vscode          = true
    vscode_insiders = false
    web_terminal    = true
    ssh_helper      = false
  }
}