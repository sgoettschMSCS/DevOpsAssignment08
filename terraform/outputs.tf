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

output "ansible_controller_public_ip" {
  description = "Public IP address of the Ansible controller"
  value       = aws_instance.ansible_controller.public_ip
}

output "ubuntu_instance_ips" {
  description = "Private IP addresses of Ubuntu instances"
  value       = aws_instance.ubuntu_instances[*].private_ip
}

output "amazon_linux_instance_ips" {
  description = "Private IP addresses of Amazon Linux instances"
  value       = aws_instance.amazon_linux_instances[*].private_ip
}

output "connection_string" {
  description = "SSH command to connect to the Ansible controller"
  value       = "ssh -i ~/midterm-key.pem ubuntu@${aws_instance.ansible_controller.public_ip}"
}

output "amazon_linux_ami_id" {
  description = "AMI ID used for Amazon Linux instances"
  value       = data.aws_ami.amazon_linux.id
}

output "ubuntu_ami_id" {
  description = "AMI ID used for Ubuntu instances"
  value       = data.aws_ami.ubuntu.id
} 