output "bucket_arn" {
  value = aws_s3_bucket.uploads_bucket.arn
}

output "bucket_name" {
  value = aws_s3_bucket.uploads_bucket.id
}
output "s3_bucket_name" {
  value = aws_s3_bucket.uploads_bucket.bucket
}