terraform {
  required_providers {
    tfe = {
      source = "hashicorp/tfe"

      # Latest fixes for tfe_workspace_run
      version = ">= 0.46.0"
    }
  }
}

variable "tfc_org" {
  type = string
}

provider "tfe" {
  organization = var.tfc_org
}

locals {
  workspaces = [
    "clumsy-bird-network",
    "clumsy-bird-compute",
  ]
}

data "tfe_workspace" "ws" {
  for_each = toset(local.workspaces)
  name     = each.key
}

resource "tfe_workspace_run" "network" {
  workspace_id = data.tfe_workspace.ws["clumsy-bird-network"].id

  apply {
    wait_for_run   = true
    manual_confirm = false
  }

  destroy {
    wait_for_run   = true
    manual_confirm = false
  }
}

resource "tfe_workspace_run" "compute" {
  workspace_id = data.tfe_workspace.ws["clumsy-bird-compute"].id

  # Use depends on to determine the order that workspaces are chained together
  depends_on = [tfe_workspace_run.network]

  apply {
    wait_for_run   = true
    manual_confirm = false
  }

  destroy {
    wait_for_run   = true
    manual_confirm = false
  }
}