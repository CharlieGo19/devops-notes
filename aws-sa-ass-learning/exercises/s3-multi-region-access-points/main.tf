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
provider "aws" {
  region = "eu-west-2"
  alias  = "london"
}

provider "aws" {
  region = "ca-central-1"
  alias  = "toronto"
}

module "iam" {
  source            = "./modules/iam"
  s3_bucket_can_arn = module.s3.s3_bucket_can_mrap_crr_demo_arn
  s3_bucket_uk_arn  = module.s3.s3_bucket_uk_mrap_crr_demo_arn
}

module "s3" {
  source                  = "./modules/s3"
  uk_bucket_name          = "united-kingdom-access-point-demo-${random_string.s3_bucket_suffix.result}"
  can_bucket_name         = "canada-access-point-demo-${random_string.s3_bucket_suffix.result}"
  canuk_access_point_name = "canuk-access-point-demo"
  canuk_iam_role          = module.iam.aws_s3_role_mrap_crr_canuk_arn
  providers = {
    aws.s3_london  = aws.london
    aws.s3_toronto = aws.toronto
  }
}

resource "random_string" "s3_bucket_suffix" {
  length  = 12
  special = false
  upper   = false
}