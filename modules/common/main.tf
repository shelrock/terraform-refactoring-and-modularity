
module "common" {
  source = "./modules/common"
  
  env = var.env
  pjt = var.pjt
  vpc_cidr = var.vpc_cidr
}