terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5"

}


provider "aws" {
  region  = var.region
  profile = "ostad-dev"
}


# -----------------------------
# VPC
# -----------------------------



resource "aws_vpc" "ostad_dev" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "demo-vpc"
  }
}


# -----------------------------
# Public Subnet
# -----------------------------


resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.ostad_dev.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    name = "public subnet"
  }
}


resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.ostad_dev.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "${var.region}b"

  tags = {
    name = "private-subnet"
  }

}


# -----------------------------
# Internet Gateway
# -----------------------------


resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.ostad_dev.id
  tags = {
    name = "demo-igw"
  }
}



# -----------------------------
# Elastic IP
# -----------------------------

resource "aws_eip" "nat" {

  domain = "vpc"

  tags = {
    name = "nat-eip"
  }

}


# -----------------------------
# NAT Gateway
# -----------------------------


resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet.id

  depends_on = [aws_internet_gateway.demo_igw]

  tags = {
    name = "demo-nat"
  }

}



# -----------------------------
# Public Route Table
# -----------------------------


resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.ostad_dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_igw.id
  }

  tags = {
    name = "public_rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id

}

# -----------------------------
# Private Route Table
# -----------------------------

resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.ostad_dev.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    name = "private-rt"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}



# -----------------------------
# Public Security Group
# -----------------------------



resource "aws_security_group" "public_sg" {
  name   = "public-sg"
  vpc_id = aws_vpc.ostad_dev.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    name = "public-sg"
  }
}



# -----------------------------
# Private Security Group
#


resource "aws_security_group" "private_sg" {
  name   = "private-sg"
  vpc_id = aws_vpc.ostad_dev.id

  ingress {
    description = "SSH from Public Security Group"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    security_groups = [
      aws_security_group.public_sg.id
    ]
  }


  egress {
    description = "all"

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    name = "private-sg"
  }

}