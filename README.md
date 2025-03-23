# AWS Infrastructure Deployment with Packer & Terraform

This project provides infrastructure-as-code for deploying a custom AWS architecture using Packer and Terraform. It creates a custom Amazon Linux AMI with Docker installed and deploys a VPC with public/private subnets, a bastion host, and EC2 instances in a private subnet.

## Prerequisites

- [AWS CLI](https://aws.amazon.com/cli/) installed and configured
- [Packer](https://www.packer.io/downloads) installed (v1.7.0+)
- [Terraform](https://www.terraform.io/downloads.html) installed (v1.0.0+)
- SSH key pair for accessing instances

## Environment Setup

The project uses GitHub Secrets for AWS credentials. Set up the following secrets in your GitHub repository:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_SESSION_TOKEN` (for AWS Learner Lab)

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

2. Generate your SSH public key if you don't have one:
   ```bash
   ssh-keygen -t rsa -b 4096
   ```

3. Update the `amazon-linux.pkr.hcl` file with your SSH public key if necessary.

4. Build the AMI:
   ```bash
   packer build amazon-linux.pkr.hcl
   ```

5. Note the AMI ID from the output for use in Terraform.

## Deploying Infrastructure with Terraform

1. Navigate to the terraform directory:
   ```bash
   cd terraform
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Update your IP address in `variables.tf` or use a tfvars file:
   ```bash
   echo 'my_ip = "YOUR_IP_ADDRESS/32"' > terraform.tfvars
   ```

4. Plan the deployment:
   ```bash
   terraform plan
   ```

5. Apply the configuration:
   ```bash
   terraform apply
   ```

6. To destroy the infrastructure when done:
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

**Note**: The private subnet instances do not have outbound internet access. This is a simplified architecture that meets the assignment requirements. In a production environment, you might want to add a NAT Gateway to allow private instances to access the internet for updates and package installations.

## Accessing Instances

1. SSH to the bastion host:
   ```bash
   ssh -i ~/.ssh/midterm-key.pem ec2-user@<bastion_public_ip>
   ```

2. From the bastion, connect directly to any private instance:
   ```bash
   ssh ec2-user@<private_instance_ip>
   ```

## Screenshots

image.png

## License

[Your License]

## Architecture Notes

This deployment creates a VPC with public and private subnets. The bastion host in the public subnet has internet access, while the instances in the private subnet are isolated from direct internet access.

**Note about NAT Gateway**: The current implementation does not include a NAT Gateway, which means the instances in the private subnet won't have outbound internet access. If your instances need to download updates, pull Docker images, or access external services, consider adding a NAT Gateway to the architecture.
