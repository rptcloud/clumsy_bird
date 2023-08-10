# output "clumsy-bird-workspace-names" {
#   value = [for p in local.workspaces : data.tfe_workspace.ws[p].name]
# }

output "clumsy-bird-url" {
  value = data.tfe_outputs.workspaces["clumsy-bird-compute-${var.environment}"].nonsensitive_values.clumsy-bird-url
}

output "clumsy-bird-ip" {
  value = data.tfe_outputs.workspaces["clumsy-bird-compute-${var.environment}"].nonsensitive_values.clumsy-bird-ip
}

output "s3_bucket" {
  value = data.tfe_outputs.workspaces["clumsy-bird-compute-${var.environment}"].nonsensitive_values.s3_bucket
}