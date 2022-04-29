terraform {
    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#CREATE IAM ROLE #
resource "aws_iam_role" "backup-role" {
  name               = var.iam-backup-role-name
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "backup-policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup-role.name
}



# BACKUP RULE #
resource "aws_backup_plan" "backup-plan" {
  name = var.backup-plan-name

  rule {
    rule_name         = var.backup-rule-name
    target_vault_name = var.target-vault-name
    schedule          = var.schedule

    lifecycle {
      delete_after = var.backup-lifecycle
    }
  }

}

# ASSIGN RESOURCES #
resource "aws_backup_selection" "backup-selection" {
  iam_role_arn = aws_iam_role.backup-role.arn
  name         = var.backup-selection-name
  plan_id      = aws_backup_plan.backup-plan.id

  resources = [
    var.backup-resource
  ]
}