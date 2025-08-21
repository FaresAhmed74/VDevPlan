terraform {
  backend "s3" {
    bucket = "terraform--fareseldesouky2002--remoteserver"
    key = "fares/terraform/remote/s3/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true

  }
}