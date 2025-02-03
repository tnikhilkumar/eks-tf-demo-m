provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"
  name    = "eks-vpc"
  cidr    = var.vpc_cidr
  azs     = data.aws_availability_zones.available.names
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.0.0"
  cluster_name    = var.cluster_name
  cluster_version = var.eks_version
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  worker_groups_launch_template = [
    {
      name                 = "worker-group"
      instance_type        = var.worker_instance_type
      asg_desired_capacity = var.desired_capacity
      subnets              = module.vpc.private_subnets
    }
  ]
}
