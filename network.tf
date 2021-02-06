# Create VPC
resource "aws_vpc" "web_vpc" {
  provider             = aws.region-web
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Web VPC"
  }
}

# Create public subnet in us-east-1a
resource "aws_subnet" "public_us_east_1a" {
  provider          = aws.region-web
  vpc_id            = aws_vpc.web_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet us-east-1a"
  }
}

# Create public subnet in us-east-1b
resource "aws_subnet" "public_us_east_1b" {
  provider          = aws.region-web
  vpc_id            = aws_vpc.web_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "Public Subnet us-east-1b"
  }
}

# Create Internet Gateway in the VPC
resource "aws_internet_gateway" "web_vpc_igw" {
  provider = aws.region-web
  vpc_id   = aws_vpc.web_vpc.id

  tags = {
    Name = "Web Internet Gateway"
  }
}

# Update route tables to use the IGW
resource "aws_route_table" "web_vpc_public" {
  provider = aws.region-web
  vpc_id   = aws_vpc.web_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web_vpc_igw.id
  }

  tags = {
    Name = "Public Route Table for Web VPC"
  }
}

resource "aws_route_table_association" "web_vpc_us_east_1a_public" {
  provider       = aws.region-web
  subnet_id      = aws_subnet.public_us_east_1a.id
  route_table_id = aws_route_table.web_vpc_public.id
}

resource "aws_route_table_association" "web_vpc_us_east_1b_public" {
  provider       = aws.region-web
  subnet_id      = aws_subnet.public_us_east_1b.id
  route_table_id = aws_route_table.web_vpc_public.id
}
