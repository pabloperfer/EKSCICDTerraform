variable "workspace_iam_roles" {
  default = {
    development    = "arn:aws:iam::916643836653:role/terraform"
    staging = "arn:aws:iam::395734858022:role/terraform"
  }
}

provider "aws" {
  assume_role = {
    region = "us-east-1"
    role_arn = "${var.workspace_iam_roles[terraform.workspace]}"
  }
}
