variable "name" {
  type        = string
  description = "Prefix for naming resources"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where security groups will be created"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks of private subnets for internal communication"
}
