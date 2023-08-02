# App Deployment Workspaces uing Chain Runner Pattern
You can safely deploy or destroy the infrastructure for the application by peforming an apply or destroy within this workspace.  This workspace is configured to manage the dependencies between the application workspaces and will run the required workspaces in the correct order.

## Create Infrastructure
- Update the `AWS Creds - Clumsy Bird` Variable Set to include the correct AWS Credentials.
- Update the `TFE_TOKEN` variable within the `clumsy-bird-app-deploy` workspace with a TFE User token.
- Inside TFC first apply the `clumsy-bird-app-deploy` workspace and this will trigger the `clumsy-bird-network` and `clumsy-bird-compute` workspaces.
- You can manage the compute independently of the network, but changes in the network will trigger changes in the compute environment.
