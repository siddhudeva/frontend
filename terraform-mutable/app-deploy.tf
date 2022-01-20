resource "null_resource" "app-deploy" {
  count = length(aws_spot_instance_request.ec2-spot)
  connection {
    type     = "ssh"
    user     = jsondecode(data.aws_secretsmanager_secret_version.secret-ssh.secret_string)["SSH_USERNAME"]
    password = jsondecode(data.aws_secretsmanager_secret_version.secret-ssh.secret_string)["SSH_PASSWD"]
    host     = aws_spot_instance_request.ec2-spot.*.private_ip[count.index]
  }

  provisioner "remote-exec" {
    inline = [
      "echo this is working fine"
    ]
  }
}
