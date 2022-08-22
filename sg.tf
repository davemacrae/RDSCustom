resource "aws_security_group" "aws-windows-sg" {
  name        = "dmacrae-windows-sg"
  description = "Allow incoming connections"
  vpc_id      = lookup(var.awsprops, "vpc")
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [format("%s/%s", data.external.whatsmyip.result["internet_ip"], 32)]
    description = "Allow incoming RDP connections"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "dmacrae-windows-sg"
  }
}

resource "aws_security_group" "aws-linux-sg" {

  vpc_id      = lookup(var.awsprops, "vpc")
  name        = "dmacrae-linux-sg"
  description = "Allow only SSH my ip"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [format("%s/%s", data.external.whatsmyip.result["internet_ip"], 32)]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "dmacrae-linux-sg"
  }
}

resource "aws_security_group" "private-linux-sg" {

  vpc_id      = lookup(var.awsprops, "vpc")
  name        = "dmacrae-private-linux-sg"
  description = "Allow only SSH my ip"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "dmacrae-linux-sg"
  }
}
