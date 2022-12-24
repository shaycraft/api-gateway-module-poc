data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "${var.namespace}-vpc"
  cidr   = "10.0.0.0/16"
}