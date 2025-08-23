# Steps:
#   1) create the vpc
#   2) create the public subnet
#   3) create the private subnet    
#   4) create the internet gateway
#   5) create the route table for public subnet  & associate it 
#   6) create the Nat gatway       
#   7) create the route table for private subnet & associate it


#   1) create the vpc
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}


#   2) create the public subnet
resource "aws_subnet" "public_subnet" {
  for_each = {
    a = { az = var.azs[0], cidr = cidrsubnet(var.vpc_cidr, 8, 0) }
    b = { az = var.azs[1], cidr = cidrsubnet(var.vpc_cidr, 8, 1) }
  }
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
  tags =  { 
    Name = "${var.project_name}-public-${each.key}"
     }
}
#   3) create the private subnet 
resource "aws_subnet" "private_subnet" {
  for_each = {
    a = { az = var.azs[0], cidr = cidrsubnet(var.vpc_cidr, 8, 3) }
    b = { az = var.azs[1], cidr = cidrsubnet(var.vpc_cidr, 8, 4) }
  }
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  tags =  { 
    Name = "${var.project_name}-private-${each.key}"
     }
}

#   4) create the internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.project_name}-IGW"
  }
}
#   5) create the route table for public subnet  & associate it 
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "${var.project_name}-rtb"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  route_table_id = aws_route_table.public_rtb.id
  for_each = aws_subnet.public_subnet
  subnet_id = each.value.id
}

#   6) create the Nat gatway 
resource "aws_eip" "eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.internet_gateway]
  tags = {
    Name= "${var.project_name}-eip"
  }
}
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public_subnet["a"].id
  tags = {
    Name = "${var.project_name}-nat"
  }
}

#   7) create the route table for private subnet & associate it
resource "aws_route_table" "eco_private_rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = { Name = "${var.project_name}-private rtb" }
}

resource "aws_route_table_association" "private_subnet_association" {
  route_table_id = aws_route_table.eco_private_rtb.id
  for_each = aws_subnet.private_subnet
  subnet_id = each.value.id
 
}