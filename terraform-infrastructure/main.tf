module "network" {
  source = "./modules/network"
  
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
}

module "compute" {
  source = "./modules/compute"
  vpc_id        = module.network.vpc_id
  environment   = var.environment
  subnet_id     = module.network.public_subnet_id
  instance_type = var.instance_type
}

module "s3" {
  source = "./modules/s3"
  
  environment   = var.environment
  bucket_prefix = var.bucket_prefix
}