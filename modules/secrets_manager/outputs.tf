output "DATABASE_USERNAME" {
  description = "The username for the database"
  value       = aws_secretsmanager_secret.db_username.name
}

output "DATABASE_PASSWORD" {
  description = "The password for the database"
  value       = aws_secretsmanager_secret.db_password.name
}
