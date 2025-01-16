locals {
  common_tags = {
    ManagedBy = "Terraform"
    Project   = "vpc-with-terraform"
  }
}


resource "aws_vpc" "custom-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = merge(local.common_tags, {
    name = "custom-vpc"
  })
}


resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.custom-vpc.id
  cidr_block = "10.0.0.0/24"

  tags = merge(local.common_tags, {
    name = "custom-public-subnet"
  })
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom-vpc.id
  tags = merge(local.common_tags, {
    name = "custom-vpc-igw"
  })
}


resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.custom-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(local.common_tags, {
    name = "public-rt"
  })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rt.id
}

