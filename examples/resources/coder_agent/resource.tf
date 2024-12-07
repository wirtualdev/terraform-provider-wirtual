data "wirtual_workspace" "me" {
}

resource "wirtual_agent" "dev" {
  os   = "linux"
  arch = "amd64"
  dir  = "/workspace"
  display_apps {
    vscode          = true
    vscode_insiders = false
    web_terminal    = true
    ssh_helper      = false
  }

  metadata {
    display_name = "CPU Usage"
    key          = "cpu_usage"
    script       = "wirtual stat cpu"
    interval     = 10
    timeout      = 1
    order        = 2
  }
  metadata {
    display_name = "RAM Usage"
    key          = "ram_usage"
    script       = "wirtual stat mem"
    interval     = 10
    timeout      = 1
    order        = 1
  }

  order = 1
}

resource "kubernetes_pod" "dev" {
  count = data.wirtual_workspace.me.start_count
  spec {
    container {
      command = ["sh", "-c", wirtual_agent.dev.init_script]
      env {
        name  = "WIRTUAL_AGENT_TOKEN"
        value = wirtual_agent.dev.token
      }
    }
  }
}
