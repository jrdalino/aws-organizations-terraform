# General
variable "aws_region" {
  type        = string
  description = "AWS Region."
}

variable "aws_account" {
  type        = string
  description = "AWS Account."
}

variable "product_domain" {
  type        = string
  description = "Product Domain."
}

variable "environment" {
  type        = string
  description = "Environment."
}

# AWS Organizations
