# --- root/main.tf ---

module "networking" {
  source           = "./networking"
  vpc_cidr         = local.vpc_cidr
  access_ip        = var.access_ip
  security_groups  = local.security_groups
  public_sn_count  = 2
  private_sn_count = 3
  max_subnets      = 20
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  db_subnet_group  = true
}

module "database" {
  source                 = "./database"
  db_storage             = 20
  db_instance_class      = "db.t2.micro"
  dbname                 = var.dbname
  dbuser                 = var.dbuser
  dbpassword             = var.dbpassword
  vpc_security_group_ids = module.networking.db_security_group
  db_subnet_group_name   = module.networking.db_subnet_group_name[0]
  db_engine_version      = "5.7.22"
  db_identifier          = "smt-db"
  skip_db_snapshot       = true
}

module "loadbalancing" {
  source                 = "./loadbalancing"
  public_sg              = module.networking.public_sg
  public_subnets         = module.networking.public_subnets
  tg_port                = 8000
  tg_protocol            = "HTTP"
  vpc_id                 = module.networking.vpc_id
  lb_healthy_threshold   = 2
  lb_unhealthy_threshold = 2
  lb_timeout             = 3
  lb_interval            = 30
  listener_port          = 8000
  listener_protocol      = "HTTP"
}

module "compute" {
  source = "./compute"
  instance_count = 1
  instance_type = "t2.micro"
  public_sg = module.networking.public_sg
  public_subnets = module.networking.public_subnets
  vol_size = 10
  public_key_path = "/home/ubuntu/.ssh/keysmt.pub"
  key_name = "smtkey"
  user_data_path = "${path.root}/userdata.tpl"
  dbname = var.dbname
  dbuser = var.dbuser
  dbpassword = var.dbpassword
  db_endpoint = module.database.db_endpoint
}

