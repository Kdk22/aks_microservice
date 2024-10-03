
variable "sql_server_name" {
  description = "The name of the SQL Server."
  type        = string
}

variable "sql_server_admin_login" {
  description = "The admin login for the SQL Server."
  type        = string
}

variable "sql_server_admin_password" {
  description = "The admin password for the SQL Server."
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "The name of the SQL Database."
  type        = string
}

variable "service_objective" {
  description = "The service objective for the SQL Database."
  type        = string
  default     = "S0"
}