# vpc vars
# cidr-block / azs / region
variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "azs" {
  description = "Availability zones for VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "project_name" {
  type    = string
  default = "ecommerce-app"
}
# ec2 vars
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "my_ip" {
  type    = string
  default = "196.131.108.151/32"
}

# S3 vars
variable "bucket_name" {
  type    = string
  default = "product-images--fareseldesouky-2002-tf"
}
#ٌRDS vars
variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  description = "Master username for MySQL"
  type        = string
  default     = "adminuser"
}

# Generate random password for RDS
resource "random_password" "db_password" {
  length  = 16
  special = true
}