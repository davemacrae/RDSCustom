resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "dmacrae - test vpc"
  }
}

# Create the Private subnets and Route Table

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 10)
  availability_zone = "eu-west-2a"
  tags = {
    "Name"  = "dmacrae-public"
    "Owner" = "dmacrae"
  }
}

resource "aws_internet_gateway" "this-igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name"  = "Application-1-gateway"
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

resource "aws_route" "internet-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.this-rt.id
  gateway_id             = aws_internet_gateway.this-igw.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.this-rt.id
}

# Create the Private subnets and Route Table

resource "aws_subnet" "private" {

  count = length(local.cidr_block)

  vpc_id            = aws_vpc.this.id
  cidr_block        = local.cidr_block[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    "Name"  = "dmacrae-private-${count.index}"
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

resource "aws_route_table_association" "private" {
  count = length(var.subnet_cidrs_private)

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private-rt.id
}

