variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"  # Update with your desired default region
}

variable "enviorment" {
  description = "Enviorment"
  type = string
  default = "dev"
}

variable "projectName" {
   description = "The name of the project"
  type = string
  default = "simple-setup"
}