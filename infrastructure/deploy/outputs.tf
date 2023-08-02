# output "clumsy-bird-workspace-names" {
#   value = data.tfe_workspace.ws[*].id
# }

# output "clumsy-bird-url" {
#   value = data.tfe_outputs.workspaces["clumsy-bird-compute"].values.clumsy-bird-url
#   depends_on = [
#     tfe_workspace_run.compute
#   ]
# }

# output "clumsy-bird-ip" {
#   value = data.tfe_outputs.workspaces["clumsy-bird-compute"].values.clumsy-bird-ip
#   depends_on = [
#     tfe_workspace_run.compute
#   ]
# }

# output "s3_bucket" {
#   value = data.tfe_outputs.workspaces["clumsy-bird-compute"].values.s3_bucket
#   depends_on = [
#     tfe_workspace_run.compute
#   ]
# }