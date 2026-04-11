provider "aws" {
  region = "us-east-1"
}

# VIOLATION: Hardcoded Cloud Credentials (Secret Scanning Trigger)
variable "aws_access_key" {
  default     = "AKIAIOSFODNN7EXAMPLE"
  description = "Temporary credentials for local testing"
}

# VIOLATION: CIS AWS 5.2 - Security Group open to the public internet
resource "aws_security_group" "app_sg" {
  name        = "enterprise_app_sg"
  description = "Application Security Group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

# VIOLATION: CIS AWS 2.2.1 - Unencrypted Block Storage
resource "aws_ebs_volume" "app_data" {
  availability_zone = "us-east-1a"
  size              = 100
  encrypted         = false 
}

# VIOLATION: CIS AWS 1.16 - IAM Wildcard (Privilege Escalation Risk)
resource "aws_iam_policy" "app_execution_role" {
  name        = "app_execution_role"
  description = "Standard application execution role"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "*" 
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}