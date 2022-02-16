terraform {
  required_version = "~> 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #  Lock version to prevent unexpected problems
      version = "3.46"
    }
  }
}




#Define provider and region
provider "aws" {
  profile                 = var.profile
  region                  = var.region
  shared_credentials_file = "~/.aws/credentials"
  ## To be removed
  #  access_key = var.acc_key
  #  secret_key = var.sec_key
}

provider "null" {}
provider "external" {}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "az" {
  state = "available"
}

