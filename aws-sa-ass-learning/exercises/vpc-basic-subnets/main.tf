terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-3"
  alias  = "paris"
}

module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = var.user_defined_ipv4_cidr
  tags_prefix = var.tags_prefix
}
