resource "aws_ssm_parameter" "access_key" {
  name  = "/dev/access_key"
  type  = "SecureString"
  value = var.access_key
}

resource "aws_ssm_parameter" "secret_key" {
  name  = "/dev/secret_key"
  type  = "SecureString"
  value = var.secret_key
}

resource "aws_ssm_parameter" "passphrase" {
  name  = "/dev/passphrase"
  type  = "SecureString"
  value = var.passphrase
}
