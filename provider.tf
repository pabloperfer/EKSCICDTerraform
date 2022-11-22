variable "workspace_iam_roles" {
  default = {
    development    = "arn:aws:iam::916643836653:role/terraform"
    staging = "arn:aws:iam::395734858022:role/terraform"
  }
}

provider "aws" {
    region = "us-east-1"
  assume_role = {
    role_arn = "${var.workspace_iam_roles[terraform.workspace]}"
  }
}
