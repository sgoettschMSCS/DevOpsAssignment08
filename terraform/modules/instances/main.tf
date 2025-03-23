# Security group for private instances
resource "aws_security_group" "private_instances" {
  name        = "${var.project_name}-private-instances-sg"
  description = "Security group for private instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
    description     = "SSH access from bastion only"
  }

  # Allow all traffic between instances in this security group
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow all traffic between instances in this security group"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name    = "${var.project_name}-private-instances-sg"
    Project = var.project_name
  }
}

# EC2 instances in private subnet
resource "aws_instance" "private_instances" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.private_instances.id]

  tags = {
    Name    = "${var.project_name}-private-instance-${count.index + 1}"
    Project = var.project_name
  }
} 