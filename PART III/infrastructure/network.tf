resource "aws_vpc" "vpc" {
  cidr_block           = "10.192.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

data "aws_availability_zones" "availability_zones" {
  state = "available"
}

resource "aws_subnet" "public_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = ["10.192.10.0/24", "10.192.11.0/24"][count.index]
  availability_zone       = data.aws_availability_zones.availability_zones.names[count.index]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = ["10.192.20.0/24", "10.192.21.0/24"][count.index]
  availability_zone       = data.aws_availability_zones.availability_zones.names[count.index]
  map_public_ip_on_launch = false
}

resource "aws_security_group" "mwaa" {
  name        = "airflow-security-group"
  description = "Security Group for Amazon MWAA Environment"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_eip" "nat_gateway_elastic_ips" {
  count = 2
  vpc   = true

  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_nat_gateway" "nat_gateways" {
  count         = 2
  allocation_id = aws_eip.nat_gateway_elastic_ips[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

}

resource "aws_route_table_association" "public_route_table_associations" {
  count          = 2
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_tables" {
  count  = 2
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateways[count.index].id
  }

}

resource "aws_route_table_association" "private_route_table_associations" {
  count          = 2
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_tables[count.index].id
}
