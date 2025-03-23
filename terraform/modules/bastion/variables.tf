variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "my_ip" {
  description = "Your IP address for SSH access (CIDR notation)"
  type        = string
}

variable "project_name" {
  description = "Name of the project for resource tagging"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the bastion host"
  type        = string
} 