terraform {
  cloud {
    organization = "Mastering-Terraform-Cloud"

    workspaces {
      name = "clumsy-bird-network"
    }
  }
}