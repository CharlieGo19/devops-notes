output "vpc_output" {
  value = module.vpc.vpc
}

output "vpc_subnets_output" {
  value = module.vpc.vpc_subnets
}