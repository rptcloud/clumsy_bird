output "clumsy-bird-compute-workspace" {
  description = "name of the clumsy bird compute workspace"
  value       = tfe_workspace.clumsy-bird-compute.name
}

output "clumsy-bird-network-workspace" {
  description = "name of the clumsy bird nework workspace"
  value       = tfe_workspace.clumsy-bird-network.name
}