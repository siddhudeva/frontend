/// ec2 instance creation using  aws spot instance requset and naming it as ec2-spot.
resource "aws_spot_instance_request" "ec2-spot" {
  count                = var.INSTANCES_NO
  ami                  = data.aws_ami.ami_ec2.id
  instance_type        = var.INSTANCES_TYPE
  wait_for_fulfillment = "true"
  tags = {
    Name = "${var.COMPONENT}-${var.ENV}-${count.index + 1}"
  }
/// adding security group to the ec2 instance and this is a private security group
  security_groups  =  [aws_security_group.sg-ec2.id]
  subnet_id = data.terraform_remote_state.vpc.outputs.private_subnet[count.index]
}
/// adding tags to the instance
resource "aws_ec2_tag" "spot-ec2" {
  count       = length(aws_spot_instance_request.ec2-spot)
  resource_id = aws_spot_instance_request.ec2-spot.*.spot_instance_id[count.index]
  key         = "Name"
  value       = "${var.COMPONENT}-${var.ENV}-${count.index + 1}"
}
///after ec2 instance creation we have to add them into TargetGroup.. these target groups are connected to "Application loadbLancer"
resource "aws_lb_target_group" "tg" {
  name     = "${var.ENV}-${var.COMPONENT}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.VPC_ID
}
//// here..! we are attaching our ec2 instances with Target groups(we created 2 private instances thats why we are using "length.index")
//// arn means amazon resource name= its is a unique name that is  given by amazon
/// target id means ec2 instance ids
resource "aws_lb_target_group_attachment" "tg-attach" {
  count            = length(aws_spot_instance_request.ec2-spot)
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_spot_instance_request.ec2-spot.*.spot_instance_id[count.index]
  port             = 80
}
///listeners are nothing but Port numbers this is for which port that load balancer will route for default.
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = data.terraform_remote_state.alb.outputs.alb_public_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}