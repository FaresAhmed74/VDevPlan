# terraform {
#   backend "s3" {
#     bucket = "terraform--fareseldesouky--remoteserver-s3"
#     key = "fares/terraform/remote/s3/terraform.tfstate"
#     region = "us-east-1"
#     dynamodb_table = "dynamodb-state-locking"
#   }
# }