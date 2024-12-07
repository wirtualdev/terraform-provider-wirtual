data "wirtual_workspace" "me" {}

resource "wirtual_agent" "dev" {
  os             = "linux"
  arch           = "amd64"
  dir            = "/workspace"
  startup_script = <<EOF
curl -fsSL https://code-server.dev/install.sh | sh
code-server --auth none --port 13337
EOF
}

resource "wirtual_app" "code-server" {
  agent_id     = wirtual_agent.dev.id
  slug         = "code-server"
  display_name = "VS Code"
  icon         = "${data.wirtual_workspace.me.access_url}/icon/code.svg"
  url          = "http://localhost:13337"
  share        = "owner"
  subdomain    = false
  healthcheck {
    url       = "http://localhost:13337/healthz"
    interval  = 5
    threshold = 6
  }
}

resource "wirtual_app" "vim" {
  agent_id     = wirtual_agent.dev.id
  slug         = "vim"
  display_name = "Vim"
  icon         = "${data.wirtual_workspace.me.access_url}/icon/vim.svg"
  command      = "vim"
}
