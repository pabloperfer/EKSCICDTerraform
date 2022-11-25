variable "workspace_iam_roles" {
  default = {
    development  = "arn:aws:iam::916643836653:role/terraform"
    staging = "arn:aws:iam::395734858022:role/terraform"
  }
}