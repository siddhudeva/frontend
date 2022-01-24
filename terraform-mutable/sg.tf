///this security group is only for alb
///creating of security groups
resource "aws_security_group" "sg-ec2" {
  name        = "${var.COMPONENT}-sg-public"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID
// ingress is inbound rules
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = data.terraform_remote_state.vpc.outputs.PRIVATE_CIDR
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = concat(data.terraform_remote_state.vpc.outputs.PRIVATE_CIDR,tolist([data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]))
  }
  // egress is outbound rules
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.COMPONENT}}-sg-public"
  }
}