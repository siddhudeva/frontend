resource "aws_security_group" "sg-ec2" {
  name        = "${var.COMPONENT}}-sg-public"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

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