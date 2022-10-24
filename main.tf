provider "aws" {
    region = "us-west-2"
}

resource "aws_s3_bucket" "unlimited_state" {
    bucket = "unlimit-up"

    lifecycle {
        create_before_destroy = true
    }

    versioning {
        enabled = true
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "unlimit-demo" {
  bucket = aws_s3_bucket.unlimited_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "unlimited_locks" {
    name = "unlimit-up-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}

terraform {
  backend "s3" {
    bucket = "unlimit-up"
    key = "global.s3/terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "unlimit-up-locks"
    encrypt = true
  }
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.unlimited_state.arn
  description = "The ARN of th S3 bucket"
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.unlimited_locks.name
  description = "The name of the DynamoDB table"
}