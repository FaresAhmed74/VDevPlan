output "alb_dns_name" {
  value = module.ec2.alb_dns_name
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "s3_bucket" {
  value = module.s3.bucket_name
}
