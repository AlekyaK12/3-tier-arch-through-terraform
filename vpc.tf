# creating vpc
resource "aws_vpc" "project3-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "project3"
  }
}

# creating subnets
resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.project3-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "pub-sub-1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.project3-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "pub-sub-2"
  }
}

resource "aws_subnet" "private_subnet3" {
  vpc_id     = aws_vpc.project3-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "pvt-sub-3"
  }
}

resource "aws_subnet" "private_subnet4" {
  vpc_id     = aws_vpc.project3-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "pvt-sub-4"
  }
}

resource "aws_subnet" "private_subnet5" {
  vpc_id     = aws_vpc.project3-vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "pvt-sub-5"
  }
}

resource "aws_subnet" "private_subnet6" {
  vpc_id     = aws_vpc.project3-vpc.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "pvt-sub-6"
  }
}

# creating internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project3-vpc.id

  tags = {
    Name = "project3_igw"
  }
}

# creating route tables
resource "aws_route_table" "public_routetable" {
  vpc_id = aws_vpc.project3-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "pub-route"
  }
}

resource "aws_route_table" "private_routetable" {
  vpc_id = aws_vpc.project3-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "pvt-route"
  }
}

# subnet associations
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_routetable.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_routetable.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.private_subnet3.id
  route_table_id = aws_route_table.private_routetable.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.private_subnet4.id
  route_table_id = aws_route_table.private_routetable.id
}

# creating elastic ip
resource "aws_eip" "elasticip" {
  domain   = "vpc"
  tags ={
    Name = "EIP"
  }
}

# creating Nat gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elasticip.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "project3-nat"
  }
}

# creating Security Group
resource "aws_security_group" "project3-sg" {
  name        = "proj3sg"
  description = "Allow SSH and HTTP and SQL and HTTPS"
  vpc_id      = aws_vpc.project3-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "proj3-sg"
  }
}