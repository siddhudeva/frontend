#data "aws_ami" "ami_ec2" {
#  most_recent      = true
#  name_regex       = "base-ec2"
#  owners           = ["self"]
#}

data "aws_ami" "ec2-ami" {
  executable_users = ["self"]
  most_recent      = true
  name_regex       = "base-ec2"
  owners           = ["self"]
}