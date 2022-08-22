resource "aws_instance" "linux-ec2" {
  ami                         = lookup(var.awsprops, "ami")
  instance_type               = lookup(var.awsprops, "itype")
  subnet_id                   = aws_subnet.dmacrae-subnet-public-1.id
  associate_public_ip_address = lookup(var.awsprops, "publicip")

  # Security Group
  vpc_security_group_ids = [aws_security_group.aws-linux-sg.id]

  # the Public SSH key
  key_name = aws_key_pair.key_pair.key_name

  root_block_device {
    delete_on_termination = true
    volume_size           = 50
    volume_type           = "gp2"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = var.EC2_USER
    private_key = file(var.PRIVATE_KEY_PATH)
  }

  tags = {
    Owner = "dmacrae"
    Stage = "Dev"
    Name  = "dmacrae linux - pub"
  }

  user_data = file("${path.module}/script.sh")
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = "AWSRDSCustomInstanceRoleForRdsCustomInstance"

}

resource "aws_instance" "private-linux-ec2" {
  ami                         = lookup(var.awsprops, "ami")
  instance_type               = lookup(var.awsprops, "itype")
  subnet_id                   = var.private-sn
  associate_public_ip_address = false

  # Security Group
  # vpc_security_group_ids = [aws_security_group.private-linux-sg.id]
  vpc_security_group_ids = ["sg-0912bbc9564da6b0b"]
  iam_instance_profile = aws_iam_instance_profile.test_profile.id

  # the Public SSH key
  key_name = aws_key_pair.key_pair.key_name

  root_block_device {
    delete_on_termination = true
    volume_size           = 50
    volume_type           = "gp2"
  }

  tags = {
    Owner = "dmacrae"
    Stage = "Dev"
    Name  = "dmacrae linux - priv"
  }

  user_data = file("${path.module}/script-priv.sh")
}

variable "EC2_USER" {
  default = "ec2-user"
}

