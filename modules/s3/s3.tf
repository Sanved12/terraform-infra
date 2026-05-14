//=======================================================================================================\\
//                                         S3 State Backend Bucket                                       \\
//=======================================================================================================\\
resource "aws_s3_bucket" "state" {
  bucket        = var.s3_conf.bucket_name
  force_destroy = true

  tags = {
    Name        = var.s3_conf.bucket_name
    Environment = var.environment
  }
}

//=======================================================================================================\\
//                                         S3 Bucket Versioning                                          \\
//=======================================================================================================\\
resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

//=======================================================================================================\\
//                                    S3 Server Side Encryption                                          \\
//=======================================================================================================\\
resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

//=======================================================================================================\\
//                                      S3 Public Access Block                                           \\
//=======================================================================================================\\
resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

//=======================================================================================================\\
//                                      DynamoDB Lock Table                                              \\
//=======================================================================================================\\
resource "aws_dynamodb_table" "lock" {
  name         = var.s3_conf.dynamodb_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = var.s3_conf.dynamodb_table
    Environment = var.environment
  }
}
