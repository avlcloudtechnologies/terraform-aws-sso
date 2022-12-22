terraform {
  required_version = ">= 0.12.23"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.34"
    }
  }
}
