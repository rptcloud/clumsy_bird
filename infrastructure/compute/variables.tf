variable "tfc_org" {
  type        = string
  description = "TFC Organization to pull remote state from"
}

variable "upstream_workspaces" {
  type    = set(string)
  default = []
}

variable "region" {
  type        = string
  description = "(Optional) The region where the resources are created. Defaults to us-east-1."
  default     = "us-east-1"
}

variable "instance_type" {
  type        = string
  description = "(Optional) Specifies the AWS instance type. Defaults to t2.micro."
  default     = "t2.micro"
}