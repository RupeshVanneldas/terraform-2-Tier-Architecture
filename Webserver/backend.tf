terraform {
  backend "s3" {
    bucket = "aws-bucket-project1"         
    key    = "webserver/terraform.tfstate"  
    region = "us-east-1"              
  }
}
