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

# 2. STORAGE (✅ REMEDIATED: Encrypted with KMS and Public Access Blocked)
resource "aws_s3_bucket" "company_data" {
  bucket = "devsecops-company-customer-data"
}

# Explicitly block all public access
resource "aws_s3_bucket_public_access_block" "company_data_access" {
  bucket                  = aws_s3_bucket.company_data.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 🚨 THE NEW FIX: Create a Customer Managed KMS Key
resource "aws_kms_key" "company_data_key" {
  description             = "KMS key for encrypting company customer data"
  deletion_window_in_days = 10
  enable_key_rotation     = true # Best practice: automatically rotate keys
}

# 🚨 THE NEW FIX: Tell the bucket to use the KMS Key instead of default AES256
resource "aws_s3_bucket_server_side_encryption_configuration" "company_data_encryption" {
  bucket = aws_s3_bucket.company_data.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.company_data_key.arn
      sse_algorithm     = "aws:kms"
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