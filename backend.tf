data "terraform_remote_state" "eks-cluster-test" {
  backend = "s3"
  config = {
    bucket = "ferpablo-terra-bucket"
    key    = "eks-cluster-test/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "dynamodb-state-locking"
  }
}

