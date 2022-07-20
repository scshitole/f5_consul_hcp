resource "random_string" "password" {
  length  = 10
  special = false
}

resource "aws_instance" "f5" {
  #F5 BIGIP-14.1.0.3-0.0.6 PAYG-Good 25Mbps-190326002717
  #ami = "ami-00a9fd893d5d15cf6" for east coast ami
  ami = var.f5ami

  instance_type               = "m5.xlarge"
  private_ip                  = "10.0.0.200"
  associate_public_ip_address = true
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [
    var.hcp_consul_security_group_id,
    aws_security_group.f5.id
  ]

  user_data                   = data.template_file.f5_init.rendered
  key_name                    = aws_key_pair.consul_client.key_name
  root_block_device {
    delete_on_termination = true
  }

  tags = {
    Name = "f5"
  }
}

data "template_file" "f5_init" {
  template = file("templates/f5.tpl")

  vars = {
    password = random_string.password.result
  }
}

