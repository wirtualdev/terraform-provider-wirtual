provider "wirtual" {}

data "wirtual_parameter" "os_selector" {
  name         = "os_selector"
  display_name = "Operating System"
  mutable      = false

  default = "osx"

  option {
    icon  = "/icons/linux.png"
    name  = "Linux"
    value = "linux"
  }
  option {
    icon  = "/icons/osx.png"
    name  = "OSX"
    value = "osx"
  }
  option {
    icon  = "/icons/windows.png"
    name  = "Windows"
    value = "windows"
  }
}

data "wirtual_parameter" "feature_cache_enabled" {
  name         = "feature_cache_enabled"
  display_name = "Enable cache?"
  type         = "bool"

  default = false
}

data "wirtual_parameter" "feature_debug_enabled" {
  name         = "feature_debug_enabled"
  display_name = "Enable debug?"
  type         = "bool"

  default = true
}

data "wirtual_workspace_tags" "custom_workspace_tags" {
  tags = {
    "cluster" = "developers"
    "os"      = data.wirtual_parameter.os_selector.value
    "debug"   = "${data.wirtual_parameter.feature_debug_enabled.value}+12345"
    "cache"   = data.wirtual_parameter.feature_cache_enabled.value == "true" ? "nix-with-cache" : "no-cache"
  }
}