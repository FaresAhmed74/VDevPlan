variable "project_name"     { type = string }
variable "vpc_id"           { type = string }
variable "public_subnets"   { type = list(string) }
variable "private_subnets"  { type = list(string) }
variable "instance_type"    { type = string }
variable "my_ip"            { type = string }
variable "instance_profile" { type = string }
variable "rds_endpoint"     { type = string }
variable "secret_arn"       { type = string }
variable "s3_bucket_name"   { type = string }
variable "tags"             { type = map(string) }

# Provide provider region to user_data
variable "region" {
  type    = string
  default = "us-east-1"
}
