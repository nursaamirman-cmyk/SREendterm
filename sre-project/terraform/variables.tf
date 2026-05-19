variable "docker_host" {
  description = "Docker daemon socket"
  type        = string
  default     = "unix:///var/run/docker.sock"
}

variable "network_name" {
  description = "Docker network name for SRE project"
  type        = string
  default     = "sre-terraform-network"
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "sre_db"
}

variable "db_user" {
  description = "PostgreSQL username"
  type        = string
  default     = "sre_user"
}

variable "db_password" {
  description = "PostgreSQL password"
  type        = string
  default     = "sre_password"
  sensitive   = true
}

variable "grafana_user" {
  description = "Grafana admin username"
  type        = string
  default     = "admin"
}

variable "grafana_password" {
  description = "Grafana admin password"
  type        = string
  default     = "sre_admin"
  sensitive   = true
}
