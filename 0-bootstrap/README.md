## Bootstrap the multi-workspace TFC Pattern
Bootstrap the clumsy bird application infrastructure by applying peforming a TFC Run in this workspace.

## Bootstrap dependencies:

- Your TFC org must have VCS set up within it to create new workspaces linked to GitHub orgs. The config here assumes exactly one GitHub VCS provider.
- The bootstrap workspace runs in Terraform Cloud too and requires the variable `TFE_TOKEN` to be set.
- This workspace is VCS connected against the `0-bootsrap` directory in the `github.com/rptcloud/clumsy_bird` repository

## Building and Destroying:

In 0-bootstrap, run terraform apply. That will create a few projects, some workspaces, and a few other resources.

There are no external dependencies outside of Terraform Cloud, to make things simple. You can totally expand upon these ideas to do things with other Providers.

When done with the exercise, run a terraform destroy to cleanup the TFC Workspaces.