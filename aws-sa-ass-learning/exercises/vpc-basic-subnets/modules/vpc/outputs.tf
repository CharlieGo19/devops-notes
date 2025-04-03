output "vpc" {
  value = {
    name = aws_vpc.new_vpc.tags.Name
    id   = aws_vpc.new_vpc.id
  }
}
output "vpc_subnets" {
  value = {
    public = [for snet in aws_subnet.public :
    format("Subnet ID: %s, IPv4 CIDR: %s, IPv6 CIDR: %s", snet.id, snet.cidr_block, snet.ipv6_cidr_block)]
    private = [for snet in aws_subnet.private :
    format("Subnet ID: %s, IPv4 CIDR: %s, IPv6 CIDR: %s", snet.id, snet.cidr_block, snet.ipv6_cidr_block)]
    data = [for snet in aws_subnet.data :
    format("Subnet ID: %s, IPv4 CIDR: %s, IPv6 CIDR: %s", snet.id, snet.cidr_block, snet.ipv6_cidr_block)]
  }
}