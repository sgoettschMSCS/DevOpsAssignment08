packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "ssh_public_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMjiDERy/1k0msqTPG8J4p5NV5X9gz4l3b/P18oRN429My1jtFQTusuluiRgP0E7Kjw5rdut8d5Fesu94je5P0f2RMNmaqz0mJZbKDF1jMMzl8o5Z5HN5h0HgcFUqx/avkLOcKqAiMv27vuPbRC6zIifSsHal0wgV01xSKQACImJRmyHTT+TIabn3Uepu/JRvnKBFfgF1iP13EwIV1iUnh4ihAl6SaWp7Zm9HXx9l1u62OZDFnrc822uQAlnY+j00dk6wRp1yUTwuQLvGSEco2l8BCq9feX7sM0Yv59ZiG61zb5dn/m7a+RSdTkjCgpBw/ulqettOW2VjT6rKmSutT"
  description = "Your SSH public key to add to the AMI"
}

source "amazon-ebs" "amazon-linux" {
  ami_name      = "amazon-linux-docker-{{timestamp}}"
  instance_type = "t2.micro"
  region        = var.aws_region
  
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  
  ssh_username = "ec2-user"
  
  tags = {
    Name        = "Amazon Linux with Docker"
    Environment = "Development"
    Project     = "AWS Packer & Terraform Assignment"
    CreatedBy   = "Packer"
    Date        = "{{timestamp}}"
  }
}

build {
  name = "amazon-linux-docker"
  sources = ["source.amazon-ebs.amazon-linux"]
  
  # Upload the authorized_keys file
  provisioner "file" {
    source      = "./files/authorized_keys"
    destination = "/tmp/authorized_keys"
  }
  
  # Setup Docker and configure SSH
  provisioner "shell" {
    script = "./scripts/setup.sh"
  }
} 