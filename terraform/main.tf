provider "aws" {
  region = "us-east-1"
}

# REMEDIATION: KMS Key for cryptographic control
resource "aws_kms_key" "enterprise_ebs_key" {
  description             = "CMK for encrypting application block storage"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

# REMEDIATION: Security Group ingress strictly scoped to private corporate CIDR
resource "aws_security_group" "app_sg" {
  name        = "enterprise_app_sg"
  description = "Application Security Group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"] 
  }
}

# REMEDIATION: EBS volume encrypted using Customer Managed Key (CMK)
resource "aws_ebs_volume" "app_data" {
  availability_zone = "us-east-1a"
  size              = 100
  encrypted         = true
  kms_key_id        = aws_kms_key.enterprise_ebs_key.arn
}

# REMEDIATION: Principle of Least Privilege enforced via explicit resource ARNs
resource "aws_iam_policy" "app_execution_role" {
  name        = "app_execution_role"
  description = "Scoped application execution role"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ec2:DescribeVolumes"] 
        Effect   = "Allow"
        Resource = [aws_ebs_volume.app_data.arn]
      },
    ]
  })
}