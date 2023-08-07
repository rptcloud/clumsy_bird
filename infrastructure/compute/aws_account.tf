# data sources
data "aws_caller_identity" "inuse" {}

# outputs
output "account_id" {
  value = data.aws_caller_identity.inuse.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.inuse.arn
}

output "caller_user" {
  value = data.aws_caller_identity.inuse.user_id
}