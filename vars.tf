variable "private-rt" {
  default = "rtb-0e27dc50be9e6b738"
}

variable "private-sn" {
  default = "subnet-0ef38413873894c8d"
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

