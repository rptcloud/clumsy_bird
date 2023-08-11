# Clumsy Bird Application

This track highlights the use of the TFC multi-space pattern to deploy the Clumsy Bird Application.  It will keep the `network` and `compute` portions of the application in seperate TFC workspaces and connect them via a `chain-runner` which uses the `tfe_workspace_run` resource to define workspace dependencies between these workspaces.

## Bootstrap the multi-workspace TFC Pattern
Bootstrap the TFC infrastructure by applying a TFC Run in the workspace - `clumsy-bird-bootstrap`.  This is a workspace that is VCS connected to `https://github.com/rptcloud/clumsy_bird` pointing to the `0-bootstrap` working directory.

## Bootstrap dependencies:
- Your TFC org must have VCS set up within it to create new workspaces linked to GitHub orgs. The config here assumes exactly one GitHub VCS provider.
- The bootstrap workspace runs in Terraform Cloud too and requires the variable `TFE_TOKEN` to be set.
- This workspace is VCS connected against the `0-bootstrap` directory in the `github.com/rptcloud/clumsy_bird` repository

## Create Infrastructure
- Update the `AWS Creds - Clumsy Bird` Variable Set to include the correct AWS Credentials.
- Update the `TFE_TOKEN` variable within the `clumsy-bird-app-deploy` workspace with a TFE User token.
- Inside TFC first apply the `clumsy-bird-app-deploy` workspace and this will trigger the `clumsy-bird-network` and `clumsy-bird-compute` workspaces.
- You can manage the compute independently of the network, but changes in the network will trigger changes in the compute environment.

- Note: If running in a free-tier Terraform Cloud, you will need to switch the "clumsy-bird-app-deploy-development" workspace to run in local mode, otherwise you will hit the 1-run concurrency limit.

## Building and Destroying:
In 0-bootstrap, run terraform apply. That will create a few projects, some workspaces, and a few other resources. There are no external dependencies outside of Terraform Cloud, to make things simple. You can totally expand upon these ideas to do things with other Providers.

When done with the exercise, run a terraform destroy in the `clumsy-bird-bootstrap` workspace to cleanup the Clumsy Bird project, workspaces and variable sets.
