provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "aws-bucket-project1" // Bucket from where to GET Terraform State
    key    = "network/terraform.tfstate"
    region = "us-east-1" // Region where bucket created
  }
}
