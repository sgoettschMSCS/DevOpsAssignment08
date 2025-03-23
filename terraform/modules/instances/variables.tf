variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the private subnet"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID created by Packer"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances to deploy"
  type        = number
}

variable "project_name" {
  description = "Name of the project for resource tagging"
  type        = string
}

variable "bastion_sg_id" {
  description = "Security group ID of the bastion host"
  type        = string
} 