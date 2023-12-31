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

provider "aws" {
  region = var.region
}

provider "tfe" {
  organization = var.tfc_org
}

# Workspaces making up the stack
locals {
  workspaces = [
    "clumsy-bird-label-${var.environment}",
    "clumsy-bird-network-${var.environment}",
    "clumsy-bird-compute-${var.environment}",
  ]
  workspaces_stack = {
    "label"   = "clumsy-bird-label-${var.environment}"
    "network" = "clumsy-bird-network-${var.environment}"
    "compute" = "clumsy-bird-compute-${var.environment}"
  }
}

data "tfe_workspace" "ws" {
  for_each = toset(local.workspaces)
  name     = each.value
}

data "tfe_outputs" "workspaces" {
  organization = var.tfc_org
  for_each     = toset(local.workspaces)
  workspace    = each.key
  depends_on = [
    tfe_workspace_run.label,
    tfe_workspace_run.network,
    tfe_workspace_run.compute,
  ]
}

resource "tfe_workspace_run" "label" {
  workspace_id = data.tfe_workspace.ws["clumsy-bird-label-${var.environment}"].id
  
  apply {
    wait_for_run   = true
    manual_confirm = false
  }

  destroy {
    wait_for_run   = true
    manual_confirm = false
  }
}

resource "tfe_workspace_run" "network" {
  workspace_id = data.tfe_workspace.ws["clumsy-bird-network-${var.environment}"].id

  # Use depends on to determine the order that workspaces are chained together
  depends_on = [tfe_workspace_run.label]

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
  workspace_id = data.tfe_workspace.ws["clumsy-bird-compute-${var.environment}"].id

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