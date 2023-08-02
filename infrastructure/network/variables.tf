variable "upstream_workspaces" {
  type    = set(string)
  default = []
}

variable "region" {
  type        = string
  description = "(Optional) The region where the resources are created. Defaults to us-east-1."
  default     = "us-east-1"
}