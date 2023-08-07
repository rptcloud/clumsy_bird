# data sources
data "aws_caller_identity" "inuse" {}

# outputs
output "aws_account_id" {
  value = data.aws_caller_identity.inuse.account_id
}

output "aws_caller_arn" {
  value = data.aws_caller_identity.inuse.arn
}

output "aws_caller_user" {
  value = data.aws_caller_identity.inuse.user_id
}