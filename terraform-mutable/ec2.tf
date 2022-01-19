resource "aws_spot_instance_request" "sample" {
  count         = var.INSTANCES_NO
  ami           = data.aws_ami.ami_ec2.id
  instance_type = var.INSTANCES_TYPE

  tags = {
    Name = "${ENV}-${COMPONENT}-${count.index +1 }"
  }
}