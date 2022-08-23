variable "private-rt" {
  default = "rtb-0e27dc50be9e6b738"
}

variable "profile" {
  description = "AWS Profile"
  default     = "default"
}

variable "region" {
  description = "AWS region"
  default     = "eu-west-2"
}

variable "vpc_id" {
  description = "AWS VPC ID"
  default     = "vpc-065973d5fba18be83"
}

variable "subnet_cidrs" {
  description = "AWS Subnet CIDR ranges"
  type        = list(any)
  default     = []
}

locals {
  account_id = aws_vpc.this.owner_id
  # account_id = "889772146711"
}

variable "itype" {
  default = "t3.micro"
}

variable "access_key" {
  type      = string
  default   = ""
  sensitive = true
}

variable "secret_key" {
  type      = string
  default   = ""
  sensitive = true
}

variable "passphrase" {
  type      = string
  default   = ""
  sensitive = true
}