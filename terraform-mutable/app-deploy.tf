resource "null_resource" "app-deploy1" {
  count = length(aws_spot_instance_request.ec2-spot)
  connection {
    type     = "ssh"
    user     = jsondecode(data.aws_secretsmanager_secret_version.secret-ssh.secret_string)["SSH_USERNAME"]
    password = jsondecode(data.aws_secretsmanager_secret_version.secret-ssh.secret_string)["SSH_PASSWD"]
    host     = aws_spot_instance_request.ec2-spot.*.private_ip[count.index]
  }

  provisioner "remote-exec" {
    inline = [
      "ansible-pull -U https://github.com/siddhudeva/ansible-1.git roboshop-pull.yml -e COMPONENT=${var.COMPONENT} -e ENV=${var.ENV}"
    ]
  }
}
