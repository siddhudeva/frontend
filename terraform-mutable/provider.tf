//// providers are nothing but sources.(where we play)
provider "aws" {
  region = "us-east-1"
}
//// S3 also comes under provider because it is providing statefiles
terraform {
  backend "s3" {}
}