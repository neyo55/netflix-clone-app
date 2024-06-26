# create a vpc for the network
resource "aws_vpc" "netflix_vpc" {
  cidr_block = var.vpc_cidr_block


  tags = {
    Name = "${var.project_name}_vpc"
  }
}

# create a subnet for the vpc
resource "aws_subnet" "netflix_subnet" {
  vpc_id                  = aws_vpc.netflix_vpc.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}_subnet"
  }
}

# create an internet gateway
resource "aws_internet_gateway" "netflix_igw" {
  vpc_id = aws_vpc.netflix_vpc.id

  tags = {
    Name = "${var.project_name}_internet_gateway"
  }
}

# create route table
resource "aws_route_table" "netflix_route_table" {
  vpc_id = aws_vpc.netflix_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.netflix_igw.id
  }

  tags = {
    Name = "${var.project_name}_route_table"
  }
}

# create route table association
resource "aws_route_table_association" "netflix_route_table_association" {
  subnet_id      = aws_subnet.netflix_subnet.id
  route_table_id = aws_route_table.netflix_route_table.id
}
    