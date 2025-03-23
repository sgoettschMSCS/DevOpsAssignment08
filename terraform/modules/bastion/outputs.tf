output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_sg_id" {
  description = "Security group ID of the bastion host"
  value       = aws_security_group.bastion.id
} 