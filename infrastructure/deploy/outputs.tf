output "clumsy-bird-workspace-names" {
  value = data.tfe_workspace.ws[*].id
}

output "clumsy-bird-url" {
  value = data.tfe_outputs.workspaces["clumsy-bird-compute"].values.clumsy-bird-url
}

output "clumsy-bird-ip" {
  value = data.tfe_outputs.workspaces["clumsy-bird-compute"].values.clumsy-bird-ip
}

output "s3_bucket" {
  value = data.tfe_outputs.workspaces["clumsy-bird-compute"].values.s3_bucket
}