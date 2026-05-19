output "postgres_container_id" {
  description = "PostgreSQL container ID"
  value       = docker_container.postgres.id
}

output "redis_container_id" {
  description = "Redis container ID"
  value       = docker_container.redis.id
}

output "prometheus_url" {
  description = "Prometheus web interface URL"
  value       = "http://localhost:9090"
}

output "grafana_url" {
  description = "Grafana web interface URL"
  value       = "http://localhost:3000"
}

output "network_id" {
  description = "Docker network ID"
  value       = docker_network.sre_network.id
}
