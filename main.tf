resource "aws_instance" "linux-ec2" {
  ami                         = data.aws_ami.amzLinux.id
  instance_type               = var.itype
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true

  # Security Group
  vpc_security_group_ids = [aws_security_group.aws-linux-sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
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

  user_data_replace_on_change = true
  user_data = templatefile("${path.module}/script.sh",
    {
      access_key_name = aws_ssm_parameter.access_key.name
      secret_key_name = aws_ssm_parameter.secret_key.name
      passphrase_name = aws_ssm_parameter.passphrase.name
  })
}

/* 
resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = "AWSRDSCustomInstanceRoleForRdsCustomInstance"

} 
*/

resource "aws_instance" "private-linux-ec2" {
  ami                         = data.aws_ami.amzLinux.id
  instance_type               = var.itype
  subnet_id                   = aws_subnet.private.id
  associate_public_ip_address = false

  # Security Group
  # vpc_security_group_ids = [aws_security_group.private-linux-sg.id]
  vpc_security_group_ids = [aws_security_group.private-linux-sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

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

  user_data_replace_on_change = true
  user_data = templatefile("${path.module}/script-priv.sh",
    {
      access_key_name = aws_ssm_parameter.access_key.name
      secret_key_name = aws_ssm_parameter.secret_key.name
      passphrase_name = aws_ssm_parameter.passphrase.name
  })
}

variable "EC2_USER" {
  default = "ec2-user"
}
