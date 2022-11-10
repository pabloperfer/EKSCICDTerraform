variable "region" {
    type = string 
    description = "region"
    default = "us-east-1"
}

variable "cidr_block" {
    type = string 
    description = "vpc ip range"
    default = "10.0.0/16"
}