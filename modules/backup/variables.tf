variable "iam-backup-role-name" {
  type = string
}

variable "backup-plan-name" {
    type = string
}

variable "backup-rule-name" {
    type = string
}

variable "target-vault-name" {
    type = string
}

variable "schedule" {
    type = string
}

variable "backup-lifecycle" {
    type = number
}

variable "backup-selection-name" {
    type = string
}

variable "backup-resource" {
  
}