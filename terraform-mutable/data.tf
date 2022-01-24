/// to get already provisioned data (Exciting data) to call it, we use data
/// this is to call aws-ami to create a ec2 using it
data "aws_ami" "ami_ec2" {
  most_recent      = true
  name_regex       = "base-ec2"
  owners           = ["self"]
}
/// we created a vpc.so we are calling it, not default one so the state files are saved in s3 bucket so we getting those info by the source of output.tf file in vpc
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraformbucket021"
    key    = "vpc/${var.ENV}/terraform.tfstate"
    region = "us-east-1"
  }
}
/// also we have created ALB also. we want that data because to create target groups
data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket = "terraformbucket021"
    key    = "vpc/${var.ENV}/alb/terraform.tfstate"
    region = "us-east-1"
  }
}
////here we are trying to get secrets form aws secrets form aws secret manager
data "aws_secretsmanager_secret" "secret" {
  name = "nexus"
}
///// why????
data "aws_secretsmanager_secret_version" "secret-ssh" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}
