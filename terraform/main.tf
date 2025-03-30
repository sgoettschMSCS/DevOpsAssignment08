# Create VPC and networking components
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = var.vpc_cidr
  availability_zone   = var.availability_zone
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  project_name        = var.project_name
  aws_region          = var.aws_region
}

# Security group for target instances (Ubuntu and Amazon Linux)
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_from_ansible"
  description = "Allow SSH inbound traffic from Ansible Controller"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "SSH from Ansible Controller"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ansible_controller_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_from_ansible"
  }
}

# Security group for Ansible Controller
resource "aws_security_group" "ansible_controller_sg" {
  name        = "ansible-controller-sg"
  description = "Security group for Ansible Controller"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Should restrict to your IP in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Ansible Controller instance - use Ubuntu AMI
resource "aws_instance" "ansible_controller" {
  ami           = data.aws_ami.ubuntu.id  # Use Ubuntu AMI
  instance_type = "t2.micro"
  key_name      = var.key_name
  subnet_id     = module.vpc.public_subnet_id  # Place in public subnet
  associate_public_ip_address = true  # Ensure it gets a public IP

  tags = {
    Name = "Ansible-Controller"
    OS   = "ubuntu"
  }

  vpc_security_group_ids = [aws_security_group.ansible_controller_sg.id]
  
  # Add user data to set up SSH and copy necessary files
  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y ansible
    apt-get install -y python3-pip
    pip3 install boto3 botocore

    # Create SSH directory and set permissions
    mkdir -p /home/ubuntu/.ssh
    chmod 700 /home/ubuntu/.ssh
    
    # Create ansible directory
    mkdir -p /home/ubuntu/ansible
    chown -R ubuntu:ubuntu /home/ubuntu/ansible
    
    # Create SSH config file to disable strict host key checking for private IPs
    cat > /home/ubuntu/.ssh/config << 'CONFIG'
    Host 10.0.*.*
      StrictHostKeyChecking no
      UserKnownHostsFile=/dev/null
    CONFIG
    
    chmod 600 /home/ubuntu/.ssh/config
    chown -R ubuntu:ubuntu /home/ubuntu/.ssh
  EOF
}

# Ubuntu instances
resource "aws_instance" "ubuntu_instances" {
  count         = var.instance_count / 2  # Half of the instances as Ubuntu
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = module.vpc.private_subnet_id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name      = var.key_name

  tags = {
    Name = "Ubuntu-Instance-${count.index + 1}"
    OS   = "ubuntu"
  }
}

# Amazon Linux instances
resource "aws_instance" "amazon_linux_instances" {
  count         = var.instance_count / 2  # Half of the instances as Amazon Linux
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = module.vpc.private_subnet_id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name      = var.key_name

  tags = {
    Name = "AmazonLinux-Instance-${count.index + 1}"
    OS   = "amazon-linux"
  }
}

# Generate Ansible inventory file
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tmpl", {
    ubuntu_ips = aws_instance.ubuntu_instances[*].private_ip,
    amazon_ips = aws_instance.amazon_linux_instances[*].private_ip
  })
  filename = "../ansible/inventory.yml"
}

# Copy inventory to Ansible controller
resource "null_resource" "copy_ansible_files" {
  depends_on = [aws_instance.ansible_controller, local_file.ansible_inventory]

  # Add a delay to ensure the instance is fully initialized
  provisioner "local-exec" {
    command = "Start-Sleep -Seconds 60"
    interpreter = ["PowerShell", "-Command"]
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "Creating inventory directory on the remote host..."
      ssh -o StrictHostKeyChecking=no -i "${var.key_path}" ubuntu@${aws_instance.ansible_controller.public_ip} "mkdir -p ~/ansible"
      
      echo "Copying inventory file..."
      scp -o StrictHostKeyChecking=no -i "${var.key_path}" ../ansible/inventory.yml ubuntu@${aws_instance.ansible_controller.public_ip}:~/ansible/
      
      echo "Copying playbook file..."
      scp -o StrictHostKeyChecking=no -i "${var.key_path}" ../ansible/playbook.yml ubuntu@${aws_instance.ansible_controller.public_ip}:~/ansible/
      
      echo "Copying SSH key to Ansible controller..."
      scp -o StrictHostKeyChecking=no -i "${var.key_path}" "${var.key_path}" ubuntu@${aws_instance.ansible_controller.public_ip}:~/.ssh/midterm-key.pem
      
      echo "Setting proper permissions on the key file..."
      ssh -o StrictHostKeyChecking=no -i "${var.key_path}" ubuntu@${aws_instance.ansible_controller.public_ip} "chmod 600 ~/.ssh/midterm-key.pem"
    EOT
    
    interpreter = ["PowerShell", "-Command"]
  }
} 