# Chain Runner

## Create Infrastructure
- Update the `AWS Creds - Clumsy Bird` Variable Set to include the correct AWS Credentials.
- Update the `TFE_TOKEN` variable within the `clumsy-bird-chain-runner` workspace with a TFE User token.
- Inside TFC first apply the `clumsy-bird-chain-runner` workspace and this will trigger the `clumsy-bird-newtork` and `clumsy-bird-compute` workspaces.
- You can manage the compute independently of the network, but changes in the network will trigger changes in the compute environment.
