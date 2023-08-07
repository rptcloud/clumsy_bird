variable "region" {
  type        = string
  description = "(Optional) The region where the resources are created. Defaults to us-east-1."
  default     = "us-east-1"
}

variable "environment" {
  description = "environment to deploy to"
  type        = string
  default     = "development"
}