# Find the most recent AMI created by Packer
data "aws_ami" "custom_ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["amazon-linux-docker-*"]
  }

  filter {
    name   = "tag:Project"
    values = ["AWS Packer & Terraform Assignment"]
  }
} 