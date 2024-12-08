provider "wirtual" {}


data "wirtual_external_auth" "github" {
  id = "github"
}

data "wirtual_external_auth" "azure-identity" {
  id       = "azure-identiy"
  optional = true
}
