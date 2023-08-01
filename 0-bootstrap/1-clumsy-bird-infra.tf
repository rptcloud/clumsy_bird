resource "tfe_project" "run-triggers" {
  name = "Clumsy Bird"
}

resource "tfe_workspace" "clumsy-bird-network" {
  name           = "clumsy-bird-network"
  auto_apply     = true
  queue_all_runs = false
  force_delete   = true
  project_id     = tfe_project.run-triggers.id

  working_directory = "infrastructure/network"

  vcs_repo {
    identifier         = "rptcloud/clumsy_bird"
    ingress_submodules = false
    oauth_token_id     = data.tfe_oauth_client.client.oauth_token_id
  }

  tag_names = ["clumsy_bird:network"]
}

resource "tfe_workspace" "clumsy-bird-compute" {
  name           = "clumsy-bird-compute"
  auto_apply     = true
  queue_all_runs = false
  force_delete   = true
  project_id     = tfe_project.run-triggers.id

  working_directory = "infrastructure/compute"

  vcs_repo {
    identifier         = "rptcloud/clumsy_bird"
    ingress_submodules = false
    oauth_token_id     = data.tfe_oauth_client.client.oauth_token_id
  }

  remote_state_consumer_ids = [
    tfe_workspace.clumsy-bird-network.id
  ]

  tag_names = ["multispace:compute"]
}

resource "tfe_variable_set" "aws-creds" {
  name = "AWS Creds - Clumsy Bird"
}

resource "tfe_variable" "tfc_org" {
  category     = "terraform"
  key          = "tfc_org"
  value        = var.tfc_org
  workspace_id = tfe_workspace.clumsy-bird-compute.id
}

resource "tfe_variable" "aws-creds" {
  key             = "AWS_ACCESS_KEY_ID"
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.aws-creds.id
}

resource "tfe_variable" "aws-creds-key" {
  key             = "AWS_SECRET_ACCESS_KEY"
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.aws-creds.id
}

resource "tfe_workspace_variable_set" "aws-creds-network" {
  variable_set_id = tfe_variable_set.aws-creds.id
  workspace_id    = tfe_workspace.clumsy-bird-network.id
}

resource "tfe_workspace_variable_set" "aws-creds-compute" {
  variable_set_id = tfe_variable_set.aws-creds.id
  workspace_id    = tfe_workspace.clumsy-bird-compute.id
}

locals {
  chain_members = [
    "A", "B", "C"
  ]

  chain_upstreams = {
    "B" = ["A"],
    "C" = ["B"],
  }
}

resource "tfe_variable" "compute-upstream-workspaces" {
  workspace_id = tfe_workspace.clumsy-bird-compute.id
  category     = "terraform"
  hcl          = true
  key          = "upstream_workspaces"
  value        = "[tfe_workspace.clumsy-bird-network.id]"
}