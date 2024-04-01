provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "my_vpc"
    Environment = "dev"
  }
}
# Public Subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, 1)
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "Public Subnet 1"
    Environment = "dev"
  }
}



# Public Subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, 3)
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "Public Subnet 2"
    Environment = "dev"
  }
}

# Public Subnet 3
resource "aws_subnet" "public_subnet_3" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, 4)
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name        = "Public Subnet 3"
    Environment = "dev"
  }
}

# Private Subnet 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, 2)
  availability_zone = "us-east-1a"

  tags = {
    Name        = "Private Subnet 1"
    Environment = "dev"
  }
}

# Private Subnet 2
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, 5)
  availability_zone = "us-east-1b"

  tags = {
    Name        = "Private Subnet 2"
    Environment = "dev"
  }
}

# Private Subnet 3
resource "aws_subnet" "private_subnet_3" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, 6)
  availability_zone = "us-east-1c"

  tags = {
    Name        = "Private Subnet 3"
    Environment = "dev"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name        = "my_igw"
    Environment = "dev"

  }
}

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name        = "public_route_table"
    Environment = "dev"
  }

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id
  }
}



# Route Table Association for public subnet 1
resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

# Route Table Association for public subnet 2
resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Route Table Association for public subnet 3
resource "aws_route_table_association" "public_subnet_association_3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public_route_table.id
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name        = "nat_gateway"
    Environment = "dev"
  }
}


# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {

  tags = {
    Name        = "nat_eip"
    Environment = "dev"
  }
}

# Route Table for private subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name        = "private_route_table"
    Environment = "dev"
  }

  route {
    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

# Route Table Association for private subnet 1
resource "aws_route_table_association" "private_subnet_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}


# Route Table Association for private subnet 2
resource "aws_route_table_association" "private_subnet_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

# Route Table Association for private subnet 3
resource "aws_route_table_association" "private_subnet_association_3" {
  subnet_id      = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private_route_table.id
}
