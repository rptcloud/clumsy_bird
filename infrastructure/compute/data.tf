locals {
  network_workspace = "clumsy-bird-network"
}

data "tfe_outputs" "vpc-id" {
  organization = var.tfc_org
  workspace    = local.network_workspace
}

data "tfe_outputs" "public_subnets" {
  organization = var.tfc_org
  workspace    = local.network_workspace
}

data "tfe_outputs" "private_subnets" {
  organization = var.tfc_org
  workspace    = local.network_workspace
}