resource "aws_spot_instance_request" "ec2-spot" {
  count         = var.INSTANCES_NO
  ami           = data.aws_ami.ami_ec2.id
  instance_type = var.INSTANCES_TYPE
  tags = {
    Name = "${var.COMPONENT}-${var.ENV}-${count.index + 1}"
  }
}
resource "aws_ec2_tag" "spot-ec2" {
  count = length(aws_spot_instance_request.ec2-spot)
  resource_id = aws_spot_instance_request.ec2-spot.*.id[count.index]
  key         = "Name"
  value       = "ec2_instance"
}