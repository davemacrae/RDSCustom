resource "aws_vpc" "this" {
  cidr_block = "10.20.20.0/25"
  tags = {
    "Name" = "dmacrae - test vpc"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.20.20.0/26"
  availability_zone = "eu-west-2a"
  tags = {
    "Name"  = "dmacrae-1-private"
    "Owner" = "dmacrae"
  }
}
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.20.20.64/26"
  availability_zone = "eu-west-2a"
  tags = {
    "Name"  = "dmacrae-1-public"
    "Owner" = "dmacrae"
  }
}
resource "aws_route_table" "this-rt" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name"  = "dmacrae-1-route-table"
    "Owner" = "dmacrae"
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name"  = "dmacrae-1-private-route-table"
    "Owner" = "dmacrae"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.this-rt.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_internet_gateway" "this-igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "Application-1-gateway"
  }
}
resource "aws_route" "internet-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.this-rt.id
  gateway_id             = aws_internet_gateway.this-igw.id
}
