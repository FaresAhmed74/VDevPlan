resource "aws_s3_bucket" "uploads_bucket" {
  bucket = var.bucket_name
  tags   =  { Name = "${var.project_name}-uploads" }
}

// to set a backup
resource "aws_s3_bucket_versioning" "v" {
  bucket = aws_s3_bucket.uploads_bucket.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.uploads_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket                  = aws_s3_bucket.uploads_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# resource "aws_s3_bucket" "mybucket" {
#   bucket = "terraform--fareseldesouky2002--remoteserver"
# }
# DynamoDB table for Terraform state locking
# resource "aws_dynamodb_table" "terraform_locks" {
#   name         = "terraform-state-locking"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }


//}
