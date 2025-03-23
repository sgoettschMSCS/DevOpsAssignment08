variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project for resource tagging"
  type        = string
  default     = "packer-terraform-assignment"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zone" {
  description = "Availability zone to use"
  type        = string
  default     = "us-east-1a"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "ami_id" {
  description = "AMI ID created by Packer"
  type        = string
  default     = ""  # This will be filled in after running Packer
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "midterm-key"  # Use the key pair from AWS Learner Lab
}

variable "instance_count" {
  description = "Number of EC2 instances to deploy in private subnet"
  type        = number
  default     = 6
}

variable "my_ip" {
  description = "Your IP address for SSH access to bastion (format: x.x.x.x/32)"
  type        = string
  default     = "0.0.0.0/0"  # CHANGE THIS TO YOUR IP FOR SECURITY!
} 