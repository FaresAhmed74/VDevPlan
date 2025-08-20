locals {
  tags = {
    Project = var.project_name
    Managed = "Terraform"
  }
}

module "vpc" {
  source       = "./modules/vpc"
  azs          = var.azs
  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name

}

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
  bucket_name  = var.bucket_name

}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
  bucket_arn   = module.s3.bucket_arn
}

module "rds" {
  source          = "./modules/rds"
  project_name    = var.project_name
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  db_name         = var.db_name
  db_username     = var.db_username
  db_password     = random_password.db_password.result
  ec2_sg_id       = null # defined later 

}


module "ec2" {
  source           = "./modules/ec2"
  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  public_subnets   = module.vpc.public_subnets
  private_subnets  = module.vpc.private_subnets
  instance_type    = var.instance_type
  my_ip            = var.my_ip
  instance_profile = module.iam.instance_profile_name
  rds_endpoint     = module.rds.rds_endpoint
  secret_arn       = module.rds.secret_arn
  s3_bucket_name   = module.s3.bucket_name
  region           = var.aws_region  # Add this line
  depends_on       = [module.iam, module.rds, module.s3]
  tags             = local.tags
}

# Now that IAM role ARN is known, attach a strict bucket policy
resource "aws_s3_bucket_policy" "uploads_strict" {
  bucket = module.s3.bucket_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyPublicAccess"
        Effect    = "Deny"
        Principal = "*"
        Action    = ["s3:*"]
        Resource = [
          module.s3.bucket_arn,
          "${module.s3.bucket_arn}/*"
        ]
        Condition = {
          Bool = { "aws:SecureTransport" = "false" }
        }
      },
      {
        Sid    = "AllowOnlyInstanceRole"
        Effect = "Allow"
        Principal = {
          AWS = module.iam.instance_role_arn
        }
        Action = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
        Resource = [
          module.s3.bucket_arn,
          "${module.s3.bucket_arn}/*"
        ]
      }
    ]
  })
}

# Let RDS SG allow MySQL from EC2 SG (requires EC2 SG id)
resource "aws_security_group_rule" "rds_from_ec2" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = module.rds.rds_sg_id
  source_security_group_id = module.ec2.ec2_sg_id
}
