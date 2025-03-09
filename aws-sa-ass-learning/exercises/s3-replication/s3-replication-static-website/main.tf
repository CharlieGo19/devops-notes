terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

module "s3" {
  source                          = "./modules/s3"

  source_bucket_name              = "source-s3-replication-${random_string.s3_bucket_suffix.result}"
  destination_bucket_name         = "destination-s3-replication-${random_string.s3_bucket_suffix.result}"
  aws_iam_role_s3_replication_arn = module.iam.aws_iam_role_s3_replication_arn
}

module "iam" {
  source                                = "./modules/iam"

  s3_bucket_replication_source_arn      = module.s3.s3_bucket_replication_source_arn
  s3_bucket_replication_destination_arn = module.s3.s3_bucket_replication_destination_arn
}

resource "random_string" "s3_bucket_suffix" {
  length  = 6
  special = false
  upper   = false
}