#!/bin/bash
set -e

# Update system
sudo yum update -y

# Install Docker
sudo amazon-linux-extras install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user

# Ensure .ssh directory exists with proper permissions
sudo mkdir -p /home/ec2-user/.ssh
sudo chmod 700 /home/ec2-user/.ssh

# Add SSH public key to authorized_keys (overwrite to ensure clean setup)
echo "${SSH_PUBLIC_KEY}" | sudo tee /home/ec2-user/.ssh/authorized_keys

# Set proper permissions
sudo chmod 600 /home/ec2-user/.ssh/authorized_keys
sudo chown -R ec2-user:ec2-user /home/ec2-user/.ssh

# Install additional utilities
sudo yum install -y git vim htop

echo "Setup completed successfully!" 