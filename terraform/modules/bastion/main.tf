# Security group for bastion host
resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
    description = "SSH access from my IP only"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.project_name}-bastion-sg"
    Project     = var.project_name
  }
}

# Bastion host instance
resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  
  # Add user data to set up SSH
  user_data = <<-EOF
    #!/bin/bash
    mkdir -p /home/ec2-user/.ssh
    chmod 700 /home/ec2-user/.ssh
    
    # Configure SSH client to use the default key for private subnet and disable strict host checking
    cat <<'CONFIG' > /home/ec2-user/.ssh/config
    Host 10.0.3.*
      User ec2-user
      StrictHostKeyChecking no
      # The key will be used from the AWS key pair automatically
    CONFIG
    
    chmod 600 /home/ec2-user/.ssh/config
    chown -R ec2-user:ec2-user /home/ec2-user/.ssh
  EOF

  tags = {
    Name    = "${var.project_name}-bastion"
    Project = var.project_name
  }
}

# Latest Amazon Linux 2 AMI for the bastion
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
} 