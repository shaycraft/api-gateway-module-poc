output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_cidr" {
  value = module.vpc.public_subnets_cidr_blocks
}