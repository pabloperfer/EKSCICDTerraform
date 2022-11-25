variable "workspace_iam_roles" {
  default = {
    development  = "arn:aws:iam::xxxxxxxxxxxx:role/terraform"
    staging = "arn:aws:iam::xxxxxxxxxxxx:role/terraform"
  }
}
