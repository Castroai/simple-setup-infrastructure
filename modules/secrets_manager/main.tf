resource "aws_secretsmanager_secret" "db_username" {
  name = "DATABASE_USERNAME"
}

resource "aws_secretsmanager_secret_version" "db_username" {
  secret_id     = aws_secretsmanager_secret.db_username.id
  secret_string = "steve"
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "DATABASE_PASSWORD"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = "password"
}
