resource "aws_internet_gateway" "dmacrae-igw" {
  vpc_id = lookup(var.awsprops, "vpc")

  tags = {
    Name = "dmacrae-igw"
  }
}

resource "aws_route_table" "dmacrae-public-crt" {
  vpc_id = lookup(var.awsprops, "vpc")

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    //CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.dmacrae-igw.id
  }

  tags = {
    Name = "dmacrae-public-crt"
  }
}

resource "aws_route_table_association" "dmacrae-crta-public-subnet-1" {
  subnet_id      = aws_subnet.dmacrae-subnet-public-1.id
  route_table_id = aws_route_table.dmacrae-public-crt.id

}

resource "aws_subnet" "dmacrae-subnet-public-1" {
  vpc_id                  = lookup(var.awsprops, "vpc")
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone       = "eu-west-2a"
  tags = {
    Name = "dmacrae-subnet-public-1"
  }
}
