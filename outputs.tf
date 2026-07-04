output "vpc_id" {
  value = aws_vpc.ostad_dev.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "public_security_group" {
  value = aws_security_group.public_sg.id
}

output "private_security_group" {
  value = aws_security_group.private_sg.id
}


output "nat_gateway" {
  value = aws_nat_gateway.nat.id
}