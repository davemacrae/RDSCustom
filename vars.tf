variable "profile" {
  description = "AWS Profile"
  default     = "default"
}

variable "region" {
  description = "AWS region"
  default     = "eu-west-2"
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

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "public_sn_cidr" {
  default = "10.20.10.0/24"
}

variable "subnet_cidrs_private" {
  description = "Subnet CIDRs for public subnets (length must match configured availability_zones)"
  # this could be further simplified / computed using cidrsubnet() etc.
  # https://www.terraform.io/docs/configuration/interpolation.html#cidrsubnet-iprange-newbits-netnum-
  default = ["10.20.20.0/24", "10.20.30.0/24", "10.20.40.0/24"]
  type    = list(string)
}


variable "availability_zones" {
  description = "AZs in this region to use"
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  type        = list(string)
}

locals {
  cidr_block = [cidrsubnet(var.vpc_cidr, 8, 20), cidrsubnet(var.vpc_cidr, 8, 30), cidrsubnet(var.vpc_cidr, 8, 40)]
}
