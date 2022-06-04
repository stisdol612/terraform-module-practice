# --- root/variable.tf ---

variable "aws_region" {
  default = "us-east-1"
}

variable "access_ip" {
  type = string
}

# --- database variables ---

variable "db_name" {
  type = string
}

variable "dbuser" {
  type      = string
  sensitive = true
}

variable "dbpassword" {
  type      = string
  sensitive = true
}