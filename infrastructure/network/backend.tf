terraform {
  cloud {
    organization = "RPTData"

    workspaces {
      name = "clumsy-bird-network"
    }
  }
}