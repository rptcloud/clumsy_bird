output "vpc-id" {
  value = module.vpc.vpc_id
}

output "azs" {
  value = module.vpc.azs
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "demo_change" {value = "sam was here 5min ago"}
