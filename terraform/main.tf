# This tells Terraform we are pretending to build in AWS
provider "aws" {
  region = "us-east-1"
}

# 🚨 THE VULNERABILITY: A Security Group with SSH open to the public internet
resource "aws_security_group" "web_server_sg" {
  name        = "web_server_sg"
  description = "Allow inbound SSH traffic"

  ingress {
    description = "SSH from anywhere (Violation of CIS 5.2)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # 0.0.0.0/0 means the entire public internet
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}