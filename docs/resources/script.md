---
# generated by https://github.com/hashicorp/terraform-plugin-docs
page_title: "wirtual_script Resource - terraform-provider-wirtual"
subcategory: ""
description: |-
  Use this resource to run a script from an agent. When multiple scripts are assigned to the same agent, they are executed in parallel.
---

# wirtual_script (Resource)

Use this resource to run a script from an agent. When multiple scripts are assigned to the same agent, they are executed in parallel.

## Example Usage

```terraform
data "wirtual_workspace" "me" {}

resource "wirtual_agent" "dev" {
  os   = "linux"
  arch = "amd64"
  dir  = "/workspace"
}

resource "wirtual_script" "dotfiles" {
  agent_id     = wirtual_agent.dev.agent_id
  display_name = "Dotfiles"
  icon         = "/icon/dotfiles.svg"
  run_on_start = true
  script = templatefile("~/get_dotfiles.sh", {
    DOTFILES_URI : var.dotfiles_uri,
    DOTFILES_USER : var.dotfiles_user
  })
}

resource "wirtual_script" "code-server" {
  agent_id           = wirtual_agent.dev.agent_id
  display_name       = "code-server"
  icon               = "/icon/code.svg"
  run_on_start       = true
  start_blocks_login = true
  script = templatefile("./install-code-server.sh", {
    LOG_PATH : "/tmp/code-server.log"
  })
}

resource "wirtual_script" "nightly_sleep_reminder" {
  agent_id     = wirtual_agent.dev.agent_id
  display_name = "Nightly update"
  icon         = "/icon/database.svg"
  cron         = "0 22 * * *"
  script       = <<EOF
    #!/bin/sh
    echo "Running nightly update"
    sudo apt-get install
  EOF
}

resource "wirtual_script" "shutdown" {
  agent_id     = wirtual_agent.dev.id
  display_name = "Stop daemon server"
  run_on_stop  = true
  icon         = "/icons/memory.svg"
  script       = <<EOF
    #!/bin/sh 
    kill $(lsof -i :3002 -t) >/tmp/pid.log 2>&1 &
  EOF
}
```

<!-- schema generated by tfplugindocs -->
## Schema

### Required

- `agent_id` (String) The `id` property of a `wirtual_agent` resource to associate with.
- `display_name` (String) The display name of the script to display logs in the dashboard.
- `script` (String) The content of the script that will be run.

### Optional

- `cron` (String) The cron schedule to run the script on. This is a cron expression.
- `icon` (String) A URL to an icon that will display in the dashboard. View built-in icons [here](https://github.com/wirtualdev/wirtual/tree/main/site/static/icon). Use a built-in icon with `"${data.wirtual_workspace.me.access_url}/icon/<path>"`.
- `log_path` (String) The path of a file to write the logs to. If relative, it will be appended to tmp.
- `run_on_start` (Boolean) This option defines whether or not the script should run when the agent starts. The script should exit when it is done to signal that the agent is ready.
- `run_on_stop` (Boolean) This option defines whether or not the script should run when the agent stops. The script should exit when it is done to signal that the workspace can be stopped.
- `start_blocks_login` (Boolean) This option determines whether users can log in immediately or must wait for the workspace to finish running this script upon startup. If not enabled, users may encounter an incomplete workspace when logging in. This option only sets the default, the user can still manually override the behavior.
- `timeout` (Number) Time in seconds that the script is allowed to run. If the script does not complete within this time, the script is terminated and the agent lifecycle status is marked as timed out. A value of zero (default) means no timeout.

### Read-Only

- `id` (String) The ID of this resource.
