provider "aws" {
  region = "us-east-1"
}

# 1. NETWORKING (Compliant)
resource "aws_security_group" "web_server_sg" {
  name        = "web_server_sg"
  description = "Allow restricted inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] 
  }
}

# 2. STORAGE (✅ REMEDIATED: Encrypted and Public Access Blocked)
resource "aws_s3_bucket" "company_data" {
  bucket = "devsecops-company-customer-data"
}

# Explicitly block all public access to the bucket
resource "aws_s3_bucket_public_access_block" "company_data_access" {
  bucket                  = aws_s3_bucket.company_data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Explicitly enforce AES256 Encryption at Rest
resource "aws_s3_bucket_server_side_encryption_configuration" "company_data_encryption" {
  bucket = aws_s3_bucket.company_data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 3. IDENTITY (✅ REMEDIATED: Least Privilege Enforced)
resource "aws_iam_policy" "strict_admin_policy" {
  name        = "strict_admin_policy"
  description = "A policy with strictly scoped access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject"] # Removed the '*' wildcard
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.company_data.arn}/*" # Scoped only to this specific bucket
      },
    ]
  })
}