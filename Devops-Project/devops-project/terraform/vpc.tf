# Aqui en vpc lo que hacemos es darle una casa "privada" a mis servidores

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16" # Rango de IP

  azs             = ["us-east-1a", "us-east-1b"]       # De este lado tenemos zonas de disponibilidad
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]     # Subredes privadas
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"] # Subredes publicas

  enable_nat_gateway = true # Habilita el gateway 
  single_nat_gateway = true # Ahorra costos en dev, usar false en prod

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment                                         = var.environment
    Project                                             = var.project_name
    "kubernetes.io/cluster/${var.project_name}-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.project_name}-cluster" = "shared"
    "kubernetes.io/role/elb"                            = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.project_name}-cluster" = "shared"
    "kubernetes.io/role/internal-elb"                   = "1"
  }
}
