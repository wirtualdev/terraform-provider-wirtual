provider "wirtual" {}

data "wirtual_git_auth" "github" {
  # Matches the ID of the git auth provider in Wirtual.
  id = "github"
}

resource "wirtual_agent" "dev" {
  os   = "linux"
  arch = "amd64"
  dir  = "~/wirtual"
  env = {
    GITHUB_TOKEN : data.wirtual_git_auth.github.access_token
  }
  startup_script = <<EOF
if [ ! -d ~/wirtual ]; then
    git clone https://github.com/wirtualdev/wirtual
fi
EOF
}