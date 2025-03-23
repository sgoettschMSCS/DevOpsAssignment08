#!/bin/bash
set -e

echo "Starting deployment process..."

# Build AMI with Packer
echo "Building AMI with Packer..."
cd packer
packer build amazon-linux.pkr.hcl
cd ..

# Deploy infrastructure with Terraform
echo "Deploying infrastructure with Terraform..."
cd terraform
terraform init
terraform apply -auto-approve

echo "Deployment complete! Use the following command to connect to the bastion host:"
terraform output connection_string

echo "Then connect to private instances using:"
echo "ssh ec2-user@<private-ip>"
echo "Private IPs:"
terraform output private_instance_ips

chmod +x deploy.sh 