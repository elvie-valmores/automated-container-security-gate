provider "aws" {
  region = "us-east-1"
}

# 1. NETWORKING (Previously Remediated, but we will leave a minor flaw)
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

# 2. STORAGE (🚨 CIS 2.1.1 VIOLATION: Unencrypted Data at Rest)
# This simulates a developer creating a bucket to store user data, but forgetting to encrypt it.
resource "aws_s3_bucket" "company_data" {
  bucket = "devsecops-company-customer-data"
}

# 3. IDENTITY (🚨 CIS 1.16 VIOLATION: IAM Wildcard Policies)
# This simulates a developer being lazy and giving an app "Full Admin" access to the entire AWS account.
resource "aws_iam_policy" "lazy_admin_policy" {
  name        = "lazy_admin_policy"
  description = "A policy that gives too much access"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "*" # The '*' means "Allow everything"
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}