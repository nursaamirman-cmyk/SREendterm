# ─────────────────────────────────────────────────────────────
# SRE Project — Terraform Infrastructure Provisioning
# Uses Docker provider for local VM simulation
# ─────────────────────────────────────────────────────────────

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = var.docker_host
}

# ── Network ──────────────────────────────────────────────────
resource "docker_network" "sre_network" {
  name   = var.network_name
  driver = "bridge"
  ipam_config {
    subnet  = "172.20.0.0/16"
    gateway = "172.20.0.1"
  }
  labels {
    label = "project"
    value = "sre-microservices"
  }
  labels {
    label = "managed_by"
    value = "terraform"
  }
}

# ── Volumes ──────────────────────────────────────────────────
resource "docker_volume" "postgres_data" {
  name   = "sre_postgres_data"
  labels {
    label = "project"
    value = "sre-microservices"
  }
}

resource "docker_volume" "prometheus_data" {
  name   = "sre_prometheus_data"
  labels {
    label = "project"
    value = "sre-microservices"
  }
}

resource "docker_volume" "grafana_data" {
  name   = "sre_grafana_data"
  labels {
    label = "project"
    value = "sre-microservices"
  }
}

# ── PostgreSQL Container ─────────────────────────────────────
resource "docker_image" "postgres" {
  name = "postgres:15-alpine"
}

resource "docker_container" "postgres" {
  name  = "tf-sre-postgres"
  image = docker_image.postgres.image_id

  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
  ]

  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }

  networks_advanced {
    name         = docker_network.sre_network.name
    ipv4_address = "172.20.0.10"
  }

  ports {
    internal = 5432
    external = 5432
  }

  healthcheck {
    test         = ["CMD-SHELL", "pg_isready -U ${var.db_user}"]
    interval     = "10s"
    timeout      = "5s"
    retries      = 5
    start_period = "10s"
  }

  restart = "unless-stopped"

  labels {
    label = "managed_by"
    value = "terraform"
  }
}

# ── Redis Container ──────────────────────────────────────────
resource "docker_image" "redis" {
  name = "redis:7-alpine"
}

resource "docker_container" "redis" {
  name    = "tf-sre-redis"
  image   = docker_image.redis.image_id
  command = ["redis-server", "--appendonly", "yes"]

  networks_advanced {
    name         = docker_network.sre_network.name
    ipv4_address = "172.20.0.11"
  }

  ports {
    internal = 6379
    external = 6379
  }

  healthcheck {
    test     = ["CMD", "redis-cli", "ping"]
    interval = "10s"
    timeout  = "5s"
    retries  = 5
  }

  restart = "unless-stopped"

  labels {
    label = "managed_by"
    value = "terraform"
  }
}

# ── Prometheus Container ─────────────────────────────────────
resource "docker_image" "prometheus" {
  name = "prom/prometheus:latest"
}

resource "docker_container" "prometheus" {
  name  = "tf-sre-prometheus"
  image = docker_image.prometheus.image_id
  command = [
    "--config.file=/etc/prometheus/prometheus.yml",
    "--storage.tsdb.path=/prometheus",
    "--web.enable-lifecycle",
    "--storage.tsdb.retention.time=30d",
  ]

  volumes {
    host_path      = abspath("${path.module}/../monitoring/prometheus")
    container_path = "/etc/prometheus"
    read_only      = true
  }

  volumes {
    volume_name    = docker_volume.prometheus_data.name
    container_path = "/prometheus"
  }

  networks_advanced {
    name         = docker_network.sre_network.name
    ipv4_address = "172.20.0.20"
  }

  ports {
    internal = 9090
    external = 9090
  }

  restart = "unless-stopped"

  labels {
    label = "managed_by"
    value = "terraform"
  }
}

# ── Grafana Container ────────────────────────────────────────
resource "docker_image" "grafana" {
  name = "grafana/grafana:latest"
}

resource "docker_container" "grafana" {
  name  = "tf-sre-grafana"
  image = docker_image.grafana.image_id

  env = [
    "GF_SECURITY_ADMIN_USER=${var.grafana_user}",
    "GF_SECURITY_ADMIN_PASSWORD=${var.grafana_password}",
    "GF_USERS_ALLOW_SIGN_UP=false",
  ]

  volumes {
    volume_name    = docker_volume.grafana_data.name
    container_path = "/var/lib/grafana"
  }

  networks_advanced {
    name         = docker_network.sre_network.name
    ipv4_address = "172.20.0.21"
  }

  ports {
    internal = 3000
    external = 3000
  }

  restart = "unless-stopped"

  labels {
    label = "managed_by"
    value = "terraform"
  }
}
