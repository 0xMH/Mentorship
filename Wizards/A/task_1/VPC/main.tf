resource "aws_vpc" "this" {
    cidr_block = var.cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "${data.aws_region.current.name}-vpc"
    }
}

data "aws_region" "current" {}

data "aws_availability_zones" "azs" {
    state = "available"
}

locals {
  azs = length(var.azs) > 0 ? var.azs : data.aws_availability_zones.azs.names

}

# Public Subnets
resource "aws_subnet" "public_subnets" {
   count = length(var.public_subnet_cidrs)
   vpc_id = aws_vpc.this.id
   cidr_block =element(var.public_subnet_cidrs, count.index)
   availability_zone = element(local.azs , count.index)
   map_public_ip_on_launch =  var.map_public_ip_on_launch

 tags = {
        Name = "${aws_vpc.this.id}-${element(local.azs , count.index)}"
        Type = "Public"
    }
}

resource "aws_route_table" "public" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.this.id
}

resource "aws_route_table_association" "public" {
    count = length(aws_route_table.public)
    subnet_id = element(aws_subnet.public_subnets[*].id , count.index)
    route_table_id = element(aws_route_table.public[*].id , count.index)
}

resource "aws_route" "public" {
    count = length(aws_route_table.public)
    route_table_id = element(aws_route_table.public[*].id , count.index)
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
}



# Private Subnets
resource "aws_subnet" "private_subnets" {
   count = length(var.private_subnet_cidrs)
   vpc_id = aws_vpc.this.id
   cidr_block =element(var.private_subnet_cidrs, count.index)
   availability_zone = element(local.azs , count.index)

 tags = {
        Name = "${aws_vpc.this.id}-${element(local.azs , count.index)}"
        Type = "Private"
    }
}

resource "aws_route_table" "private" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.this.id
}

resource "aws_route_table_association" "private" {
    count = length(aws_route_table.private)
    subnet_id = element(aws_subnet.private_subnets[*].id , count.index)
    route_table_id = element(aws_route_table.private[*].id , count.index)
}




# Internet Gateway

resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id
}

# NAT Gateway
locals {
  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(local.azs) : max(length(var.public_subnet_cidrs) , length(var.private_subnet_cidrs))
}


resource "aws_eip" "eips" {
    count = local.nat_gateway_count
    domain = "vpc"
}
resource "aws_nat_gateway" "this" {
    count = local.nat_gateway_count
    subnet_id = element(aws_subnet.public_subnets[*].id , count.index)
    allocation_id = element(aws_eip.eips[*].id , count.index)

    depends_on = [aws_internet_gateway.this]
}



resource "aws_route" "private" {
    count = length(aws_route_table.private)
    route_table_id = element(aws_route_table.private[*].id , count.index)
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.this[*].id , count.index)
}

