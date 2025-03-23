output "private_instance_ips" {
  description = "Private IP addresses of instances in the private subnet"
  value       = aws_instance.private_instances[*].private_ip
} 