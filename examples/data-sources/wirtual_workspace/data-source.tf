data "wirtual_workspace" "dev" {
}

resource "kubernetes_pod" "dev" {
  count = data.wirtual_workspace.dev.transition == "start" ? 1 : 0
}
