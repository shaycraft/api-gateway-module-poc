data "aws_availability_zones" "available" {}

module "vpc" {
  source                       = "terraform-aws-modules/vpc/aws"
  name                         = "${var.namespace}-vpc"
  cidr                         = "10.0.0.0/16"
  public_subnets               = ["10.0.1.0/24", "10.0.2.0/24"]
  azs                          = data.aws_availability_zones.available.names
  create_database_subnet_group = false
  enable_nat_gateway           = false
  tags = {
    Name      = "vpc terraform module poc"
    CreatedBy = "terraform"
  }
}