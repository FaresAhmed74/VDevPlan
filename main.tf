terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

    backend "s3" {
      bucket = "terraform--fareseldesouky2002--remoteserver"
      key    = "eks-nginx/terraform.tfstate"
      region = "us-east-1"
      use_lockfile = true
    }
}

provider "aws" {
  region = var.region
}
#vpc modulke
module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  azs          = var.azs
}

#eks module
module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  cluster_role_arn   = module.iam.eks_cluster_role_arn
  node_role_arn      = module.iam.eks_node_role_arn
  private_subnet_ids = module.vpc.private_subnets
  node_instance_type = var.node_instance_type

}

#iam module
module "iam" {
  source       = "./modules/iam"
  cluster_name = var.cluster_name
}

# security group module
module "security_group" {
  source               = "./modules/security_group"
  vpc_id               = module.vpc.vpc_id
  name                 = var.project_name
  private_subnet_cidrs = var.private_subnet_cidrs
}
