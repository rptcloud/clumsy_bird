## Creating Project

resource "tfe_project" "clumsy_bird" {
  name = "Clumsy Bird"
}

## Creating Workspaces

resource "tfe_workspace" "clumsy-bird-label" {
  for_each       = var.environments
  name           = "clumsy-bird-label-${each.value}"
  auto_apply     = true
  queue_all_runs = false
  force_delete   = true
  project_id     = tfe_project.clumsy_bird.id

  working_directory = "infrastructure/label"

  vcs_repo {
    identifier         = "rptcloud/clumsy_bird"
    ingress_submodules = false
    oauth_token_id     = data.tfe_oauth_client.client.oauth_token_id
  }

  remote_state_consumer_ids = [
    tfe_workspace.chain-runner["${each.value}"].id,
    tfe_workspace.clumsy-bird-network["${each.value}"].id,
    tfe_workspace.clumsy-bird-compute["${each.value}"].id,
  ]

  tag_names = ["clumsy_bird:${each.value}:label"]
}

resource "tfe_workspace" "clumsy-bird-network" {
  for_each       = var.environments
  name           = "clumsy-bird-network-${each.value}"
  auto_apply     = true
  queue_all_runs = false
  force_delete   = true
  project_id     = tfe_project.clumsy_bird.id

  working_directory = "infrastructure/network"

  vcs_repo {
    identifier         = "rptcloud/clumsy_bird"
    ingress_submodules = false
    oauth_token_id     = data.tfe_oauth_client.client.oauth_token_id
  }

  remote_state_consumer_ids = [
    tfe_workspace.chain-runner["${each.value}"].id,
    tfe_workspace.clumsy-bird-compute["${each.value}"].id,
  ]

  tag_names = ["clumsy_bird:${each.value}:network"]
}

resource "tfe_workspace" "clumsy-bird-compute" {
  for_each       = var.environments
  name           = "clumsy-bird-compute-${each.value}"
  auto_apply     = true
  queue_all_runs = false
  force_delete   = true
  project_id     = tfe_project.clumsy_bird.id

  working_directory = "infrastructure/compute"

  vcs_repo {
    identifier         = "rptcloud/clumsy_bird"
    ingress_submodules = false
    oauth_token_id     = data.tfe_oauth_client.client.oauth_token_id
  }

  remote_state_consumer_ids = [
    tfe_workspace.chain-runner["${each.value}"].id
  ]

  tag_names = ["clumsy_bird:${each.value}:compute"]
}

resource "tfe_workspace" "chain-runner" {
  for_each       = var.environments
  name           = "clumsy-bird-app-deploy-${each.value}"
  auto_apply     = true
  queue_all_runs = false
  force_delete   = true
  project_id     = tfe_project.clumsy_bird.id

  working_directory = "infrastructure/deploy"

  vcs_repo {
    identifier         = "rptcloud/clumsy_bird"
    ingress_submodules = false
    oauth_token_id     = data.tfe_oauth_client.client.oauth_token_id
  }

  tag_names = ["clumsy_bird:${each.value}:deployment-runner"]
}

## Creating Variables and Variable Sets

resource "tfe_variable_set" "aws-creds" {
  for_each = var.environments
  name     = "AWS Creds - Clumsy Bird - ${each.value}"
}

resource "tfe_variable_set" "tfc-org" {
  for_each = var.environments
  name     = "App Specific - Clumsy Bird - ${each.value}"
}

resource "tfe_variable" "tfc_org" {
  for_each        = var.environments
  category        = "terraform"
  key             = "tfc_org"
  value           = var.tfc_org
  variable_set_id = tfe_variable_set.tfc-org["${each.value}"].id
}

resource "tfe_variable" "environment" {
  for_each        = var.environments
  category        = "terraform"
  key             = "environment"
  value           = each.value
  variable_set_id = tfe_variable_set.tfc-org["${each.value}"].id
}

resource "tfe_variable" "aws-creds" {
  for_each        = var.environments
  key             = "AWS_ACCESS_KEY_ID"
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.aws-creds["${each.value}"].id
}

resource "tfe_variable" "aws-creds-key" {
  for_each        = var.environments
  key             = "AWS_SECRET_ACCESS_KEY"
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.aws-creds["${each.value}"].id
}

resource "tfe_workspace_variable_set" "aws-creds-deploy" {
  for_each        = var.environments
  variable_set_id = tfe_variable_set.aws-creds["${each.value}"].id
  workspace_id    = tfe_workspace.chain-runner["${each.value}"].id
}

resource "tfe_workspace_variable_set" "aws-creds-network" {
  for_each        = var.environments
  variable_set_id = tfe_variable_set.aws-creds["${each.value}"].id
  workspace_id    = tfe_workspace.clumsy-bird-network["${each.value}"].id
}

resource "tfe_workspace_variable_set" "aws-creds-compute" {
  for_each        = var.environments
  variable_set_id = tfe_variable_set.aws-creds["${each.value}"].id
  workspace_id    = tfe_workspace.clumsy-bird-compute["${each.value}"].id
}

resource "tfe_workspace_variable_set" "app-config-deploy" {
  for_each        = var.environments
  variable_set_id = tfe_variable_set.tfc-org["${each.value}"].id
  workspace_id    = tfe_workspace.chain-runner["${each.value}"].id
}

resource "tfe_workspace_variable_set" "app-config-label" {
  for_each        = var.environments
  variable_set_id = tfe_variable_set.tfc-org["${each.value}"].id
  workspace_id    = tfe_workspace.clumsy-bird-label["${each.value}"].id
}

resource "tfe_workspace_variable_set" "app-config-network" {
  for_each        = var.environments
  variable_set_id = tfe_variable_set.tfc-org["${each.value}"].id
  workspace_id    = tfe_workspace.clumsy-bird-network["${each.value}"].id
}

resource "tfe_workspace_variable_set" "app-config-compute" {
  for_each        = var.environments
  variable_set_id = tfe_variable_set.tfc-org["${each.value}"].id
  workspace_id    = tfe_workspace.clumsy-bird-compute["${each.value}"].id
}

resource "tfe_variable" "compute-upstream-workspaces" {
  for_each     = var.environments
  workspace_id = tfe_workspace.clumsy-bird-compute["${each.value}"].id
  category     = "terraform"
  hcl          = true
  key          = "upstream_workspaces"
  value = jsonencode([
    "${tfe_workspace.clumsy-bird-network["${each.value}"].name}",
  ])
}

resource "tfe_variable" "chain-runner-tfc_org" {
  for_each     = var.environments
  category     = "terraform"
  key          = "tfc_org"
  value        = var.tfc_org
  workspace_id = tfe_workspace.chain-runner["${each.value}"].id
}

resource "tfe_variable" "chain-runner-tfe-token" {
  for_each     = var.environments
  category     = "env"
  key          = "TFE_TOKEN"
  sensitive    = true
  workspace_id = tfe_workspace.chain-runner["${each.value}"].id
}