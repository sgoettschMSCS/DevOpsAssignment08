output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = module.vpc.private_subnet_id
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = module.bastion.bastion_public_ip
}

output "private_instance_ips" {
  description = "Private IP addresses of instances in the private subnet"
  value       = module.instances.private_instance_ips
}

output "connection_string" {
  description = "SSH command to connect to the bastion host"
  value       = "ssh -i ~/.ssh/midterm-key.pem ec2-user@${module.bastion.bastion_public_ip}"
}

output "ami_id" {
  description = "AMI ID used for private instances"
  value       = data.aws_ami.custom_ami.id
} 