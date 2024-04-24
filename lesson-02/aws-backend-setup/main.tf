terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}
#define a S3 bucket to store terraform state, bucket ="name" must be unique across S3 buckets globally 
resource "aws_s3_bucket" "terraform-state-bkt" {
  #must be unique globally check this carefully
  bucket = "cris-ortiz-tfstate82"
  #enables to destroy de bucket including the content
  force_destroy = true
}
#to configure versioning for the created bucket
resource "aws_s3_bucket_versioning" "terraform-state-bkt-bucket-versioning" {
  #gets the id from the bucket created before
  bucket = aws_s3_bucket.terraform-state-bkt.id
  versioning_configuration {
    status = "Enabled"
  }
}
#to configure server side encryption for the created bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform-state-bkt-crypto-conf" {
  bucket = aws_s3_bucket.terraform-state-bkt.bucket
  #encryption ruls
  rule {
    #default encryption applied and sse algo to apply
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
#dybamoDB table to enable terraform state lock (avoid state overwriring)
resource "aws_dynamodb_table" "terraform-locks" {
  name         = "cris-ortiz-tf-statelocking82"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}