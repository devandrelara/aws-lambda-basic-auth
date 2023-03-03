resource "aws_ssm_parameter" "webhook_user" {
  name  = "webhook_user"
  type  = "SecureString"
  value = "admin"
}

resource "aws_ssm_parameter" "webhook_password" {
  name  = "webhook_password"
  type  = "SecureString"
  value = "passwd"
}