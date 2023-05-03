variable "aws_region" {
  type        = string
  description = "AWS Region to create resources in"
}
variable "account" {
  type        = string
  description = "Name of the account."
}
variable "environment" {
  type        = string
  description = "Environment resources are being created for"
}
variable "app_name" {
  type        = string
  description = "Name of the services being created"
}