output "service_principal_secret" {
  description = "The service principal client secret."
  value       = "${random_string.service_principal_password_txt.result}"
}
