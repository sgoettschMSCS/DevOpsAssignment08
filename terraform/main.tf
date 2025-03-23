# Create VPC and networking components
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = var.vpc_cidr
  availability_zone   = var.availability_zone
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  project_name        = var.project_name
}

# Create bastion host
module "bastion" {
  source = "./modules/bastion"

  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  instance_type    = var.instance_type
  ami_id           = data.aws_ami.custom_ami.id
  key_name         = var.key_name
  my_ip            = var.my_ip
  project_name     = var.project_name
}

# Create private instances
module "instances" {
  source = "./modules/instances"

  vpc_id            = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_id
  instance_type     = var.instance_type
  ami_id            = data.aws_ami.custom_ami.id
  key_name          = var.key_name
  instance_count    = var.instance_count
  project_name      = var.project_name
  bastion_sg_id     = module.bastion.bastion_sg_id
} 