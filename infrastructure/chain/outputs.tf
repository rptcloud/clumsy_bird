output "clumsy-bird-compute-workspace-name" {
  value = data.tfe_workspace.ws["clumsy-bird-compute"].name
}

output "clumsy-bird-compute-workspace-id" {
  value = data.tfe_workspace.ws["clumsy-bird-compute"].id
}

output "clumsy-bird-network-workspace-name" {
  value = data.tfe_workspace.ws["clumsy-bird-network"].name
}

output "clumsy-bird-network-workspace-id" {
  value = data.tfe_workspace.ws["clumsy-bird-network"].id
}