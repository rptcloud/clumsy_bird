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
    tfe_workspace.run-triggers-nework.id
  ]

  tag_names = ["multispace:compute"]
}

resource "tfe_variable" "run-triggers-upstream-b-tfc_org" {
  category     = "terraform"
  key          = "tfc_org"
  value        = var.tfc_org
  workspace_id = tfe_workspace.run-triggers-upstream-b.id
}

resource "tfe_variable" "tfc_org" {
  category     = "terraform"
  key          = "tfc_org"
  value        = var.tfc_org
  workspace_id = tfe_workspace.clumsy-bird-compute.id
}

resource "tfe_workspace_run" "compute" {
  workspace_id = tfe_workspace.clumsy-bird-compute.id

  depends_on = [tfe_variable.tfc_org]

  apply {
    # Fire and Forget
    wait_for_run = false
    # auto-apply
    manual_confirm = yes
  }

  destroy {
    # Wait for destroy before doing anything else
    wait_for_run = true
    # auto-apply
    manual_confirm = yes
  }
}