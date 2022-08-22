data "external" "whatsmyip" {
  program = ["/bin/bash", "${path.module}/whatsmyip.sh"]
}

variable "awsprops" {
  type = map(string)
  default = {
    vpc          = "vpc-065973d5fba18be83"
    ami          = "ami-0dd555eb7eb3b7c82"
    itype        = "t3.micro"
    publicip     = "true"
    sec_group_id = "sg-0ae9e71277603599b"
  }
}


