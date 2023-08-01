# Clumsy Bird Application

## Create Infrastructure
- Update the `AWS Creds - Clumsy Bird` Variable Set to include the correct AWS Credentials.
- Inside TFC first apply the `clumsy-bird-newtwork` workspace and this will trigger the `clumsy-bird-compute` workspace.
- You can manage the compute independently of the network, but changes in the network will trigger changes in the compute environment.

