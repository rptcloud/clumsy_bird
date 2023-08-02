terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "label" {
  source      = "cloudposse/label/null"
  version     = "0.25.0"
  delimiter   = "-"
  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  name        = var.name

  tags = {
    BusinessUnit = var.business_unit
    ManagedBy    = "Terraform"
  }

  additional_tag_map = {
    propagate_at_launch = "true"
  }

}