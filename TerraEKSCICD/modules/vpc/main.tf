data "aws_availability_zones" "available" {}

resource "aws_vpc" "EKS_VPC" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = true

  tags = {
    Name = "var.vpcName"
  }
}

resource "aws_subnet" "public_subnet" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.EKS_VPC.id}"
  cidr_block = "10.0.${1+count.index}.0/24"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet.${1+count.index}"
  }
}
