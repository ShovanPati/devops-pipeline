provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "artifact_bucket" {
  bucket = var.bucket_name
}

# Enable versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.artifact_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption with AWS-managed key (AES256)
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.artifact_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable logging
resource "aws_s3_bucket_logging" "logging" {
  bucket = aws_s3_bucket.artifact_bucket.id

  target_bucket = aws_s3_bucket.artifact_bucket.id
  target_prefix = "log/"
}

# Public access block
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.artifact_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}
