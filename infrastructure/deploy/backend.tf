terraform {
  cloud {
    organization = "RPTData"

    workspaces {
      name = "clumsy-bird-app-deploy"
    }
  }
}