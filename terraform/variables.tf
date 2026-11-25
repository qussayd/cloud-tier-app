variable "aws_region" {
  description = "AWS Region to deploy resources"
  type        = string
  default     = "eu-central-1"
}

variable "db_password" {
  description = "PostgreSQL root password"
  type        = string
  sensitive   = true
}
