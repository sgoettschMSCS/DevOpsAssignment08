output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets (for backward compatibility)"
  value       = [aws_subnet.public.id]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets (for backward compatibility)"
  value       = [aws_subnet.private.id]
} 