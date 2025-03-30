# AWS Infrastructure Deployment with Packer & Terraform brachned?

This project provides infrastructure-as-code for deploying a custom AWS architecture using Packer and Terraform. It creates a custom Amazon Linux AMI with Docker installed and deploys a VPC with public/private subnets, a bastion host, and EC2 instances in a private subnet.

## Prerequisites

- [AWS CLI](https://aws.amazon.com/cli/) installed and configured
- [Packer](https://www.packer.io/downloads) installed (v1.7.0+)
- [Terraform](https://www.terraform.io/downloads.html) installed (v1.0.0+)
- SSH key pair for accessing instances

## Environment Setup


For local development, set these environment variables:

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_SESSION_TOKEN="your-session-token"
export AWS_REGION="us-east-1"
```

## Building the AMI with Packer

1. Navigate to the packer directory:
   ```bash
   cd packer
   ```

2. Build the AMI:
   ```bash
   packer build amazon-linux.pkr.hcl
   ```

## Deploying Infrastructure with Terraform

1. Navigate to the terraform directory:
   ```bash
   cd terraform
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Apply the configuration:
   ```bash
   terraform apply -auto-approve
   ```

4. To destroy the infrastructure when done:
   ```bash
   terraform destroy
   ```

## Architecture

This deployment creates:
- A VPC with 1 public and 1 private subnet
- Internet Gateway for public subnet connectivity
- 1 bastion host in the public subnet (restricted to your IP on port 22)
- 6 EC2 instances in the private subnet using the custom AMI
- Security groups with minimal required access


## Accessing Instances

1. SSH to the bastion host:
   ```bash
   ssh -i ~/.ssh/*.pem ec2-user@<bastion_public_ip>
   ```

2. From the bastion, connect directly to any private instance:
   ```bash
   ssh ec2-user@<private_instance_ip>
   ```

## Screenshots with inputs and expected outputs:

cd ../packer
packer build amazon-linux.pkr.hcl

![image](https://github.com/user-attachments/assets/a09444fd-5d07-4c88-9b7f-a66886256abc)
![image](https://github.com/user-attachments/assets/94d53e7f-09e2-48b5-bfe8-9e1557c57d8a)


cd ../terraform
terraform init
terraform apply -auto-approve

![image](https://github.com/user-attachments/assets/6d22ace9-8ad4-4cc3-9438-8a8cea2a9c9b)
![image](https://github.com/user-attachments/assets/4bc1d53a-81e9-4677-bce4-4ee0f5830988)


terraform destroy

![image](https://github.com/user-attachments/assets/7e30818c-d1ec-4c79-9f62-99927aebd210)
![image](https://github.com/user-attachments/assets/bbe4fdfd-9a71-4d75-9013-2e829b711af1)

## Assignment 10 - Ansible Configuration

This repository has been updated with Ansible integration to manage the provisioned EC2 instances.

### Infrastructure Overview

The terraform configuration now provisions:
- 3 Ubuntu EC2 instances tagged with OS:ubuntu
- 3 Amazon Linux EC2 instances tagged with OS:amazon  
- 1 Ansible Controller EC2 instance running Ubuntu

### Deployment Steps

1. Clone the repository and checkout the assignment10 branch:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   git checkout assignment10
   ```

2. Provision the infrastructure:
   ```bash
   cd terraform
   terraform init
   terraform apply -auto-approve
   ```

3. Connect to the Ansible Controller:
   ```bash
   ssh -i ~/.ssh/your-key.pem ubuntu@<ansible-controller-public-ip>
   ```

4. Run the Ansible playbook:
   ```bash
   cd ~/ansible
   ansible-playbook -i inventory.yml playbook.yml
   ```

### What the Ansible Playbook Does

1. Updates and upgrades all packages on each instance
2. Verifies and ensures Docker is installed and running on all instances 
3. Reports disk usage for each instance

### Output

The playbook will output:
- Package update status
- Docker version information
- Disk usage details for each server

## Screenshots for Assignment 10:

terraform init, plan, apply


ssh -i * ubuntu@*


ansible-playbook -i inventory.yml playbook.yml




