# outputs -> vpc ids and subnet ids
output "vpc_id" {
  value = aws_vpc.ecommerce_vpc.id
}

output "public_subnets" {
  value = [for s in aws_subnet.public_subnet : s.id]
}

output "private_subnets" {
  value = [for s in aws_subnet.private_subnet : s.id]
}