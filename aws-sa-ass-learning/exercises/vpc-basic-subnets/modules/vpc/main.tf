locals {
  # Sort available zones, based on a Paris provider.
  azs = sort(data.aws_availability_zones.available.names)
  # 3 Tier App across 3 AZ's with an AZ for future use should it be needed.
  cidrs      = cidrsubnets(var.vpc_cidr, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4)
  snet_types = ["public", "private", "data"]

  snet_details = {
    for index, type in local.snet_types :
    type => {
      for cidr_index, cidr in slice(local.cidrs, index * 3, index * 3 + length(local.azs)) :
      "${type}-${local.azs[cidr_index]}" => {
        az                = local.azs[cidr_index]
        alloc_ipv4_cidr   = cidr
        alloc_ipv6_netnum = index * 3 + cidr_index
      }
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "new_vpc" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "${var.tags_prefix}-cgo19"
  }
}

# These are separate because they'll have different network and security configurations.
resource "aws_subnet" "data" {
  for_each = local.snet_details.data

  vpc_id            = aws_vpc.new_vpc.id
  availability_zone = each.value.az
  cidr_block        = each.value.alloc_ipv4_cidr
  ipv6_cidr_block   = cidrsubnet(aws_vpc.new_vpc.ipv6_cidr_block, 8, each.value.alloc_ipv6_netnum)

  tags = {
    Name = "${var.tags_prefix}-${each.key}"
  }

}

resource "aws_subnet" "private" {
  for_each = local.snet_details.private

  vpc_id            = aws_vpc.new_vpc.id
  availability_zone = each.value.az
  cidr_block        = each.value.alloc_ipv4_cidr
  ipv6_cidr_block   = cidrsubnet(aws_vpc.new_vpc.ipv6_cidr_block, 8, each.value.alloc_ipv6_netnum)

  tags = {
    Name = "${var.tags_prefix}-${each.key}"
  }
}

resource "aws_subnet" "public" {
  for_each = local.snet_details.public

  vpc_id            = aws_vpc.new_vpc.id
  availability_zone = each.value.az
  cidr_block        = each.value.alloc_ipv4_cidr
  ipv6_cidr_block   = cidrsubnet(aws_vpc.new_vpc.ipv6_cidr_block, 8, each.value.alloc_ipv6_netnum)

  tags = {
    Name = "${var.tags_prefix}-${each.key}"
  }
}
