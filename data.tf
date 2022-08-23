data "external" "whatsmyip" {
  program = ["/bin/bash", "${path.module}/whatsmyip.sh"]
}


data "aws_ami" "amzLinux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
}
