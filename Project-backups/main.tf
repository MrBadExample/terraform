
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

# BACKEND
  backend "s3" {
    # profile = "saml"
    region = "us-east-1"
    bucket = "backend-szymon-s3"
    key = "environment-base/terraform.tfstate" 
    encrypt = true
    
  }
  
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "AKIA4JDQWJWW6NRQPWVV"
  secret_key = "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"
  # profile = "saml"
  version = "3.74.0"
}


# S3 BUCKET
resource "aws_s3_bucket" "backend-szymon-s3" {
  bucket = "backend-szymon-s3" 

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

}

# EFS
resource "aws_efs_file_system" "jira-efs" {
  tags = {
    Name = "jira-efs"
  }
}


module "backup-module" {
  source = "/Users/rostek/terraform/modules/backup"

  #ROLE
  iam-backup-role-name = "backup-role"

  #BACKUP
  backup-plan-name = "backup-plan"
  backup-rule-name = "backup-rule"
  target-vault-name = "Default"
  schedule = "cron(0 12 * * ? *)"
  backup-lifecycle = 30

  #BACKUP SELCTION
  backup-selection-name = "efs-backup-selection"
  backup-resource = aws_efs_file_system.jira-efs.arn
  
}



