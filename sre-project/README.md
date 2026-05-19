# End-to-End SRE Implementation — Distributed Microservices System

> **End Term Project** — Site Reliability Engineering  
> Multi-orchestrated microservices infrastructure using Docker Swarm, Kubernetes, Terraform, and Ansible

---

## 📐 Architecture

```
User → Frontend (Nginx:80) → API Gateway
                               ↓
         ┌─────────────────────┼───────────────────────┐
    Auth(5001)  Product(5002)  Order(5003)  Payment(5004)
                         Notify(5005)  UserProfile(5006)
                               ↓
                    PostgreSQL + Redis
                               ↓
             Prometheus(9090) → Grafana(3000)
             Terraform → VM Provisioning
             Ansible  → Config & Deployment
             Docker Swarm + Kubernetes → Orchestration
```

## 🚀 Quick Start

### Prerequisites
- Docker 24+ and Docker Compose
- (Optional) Minikube for Kubernetes
- (Optional) Terraform 1.0+
- (Optional) Ansible 2.12+

### Run Everything with Docker Compose

```bash
# 1. Clone the repository
git clone <YOUR_REPO_URL>
cd sre-project

# 2. Start all services
docker-compose up --build -d

# 3. Check status
bash scripts/health_check.sh
```

### Access Points

| Service | URL | Credentials |
|---------|-----|-------------|
| Frontend | http://localhost:80 | — |
| Prometheus | http://localhost:9090 | — |
| Grafana | http://localhost:3000 | admin / sre_admin |
| Auth API | http://localhost:5001 | — |
| Product API | http://localhost:5002 | — |
| Order API | http://localhost:5003 | — |
| Payment API | http://localhost:5004 | — |
| Notification API | http://localhost:5005 | — |
| User Profile API | http://localhost:5006 | — |

---

## 🔧 Microservices (Assignment 1)

| Service | Port | Description | Endpoints |
|---------|------|-------------|-----------|
| Auth | 5001 | User authentication | POST /login, POST /validate, GET /health |
| Product | 5002 | Product catalog | GET /products, POST /products, GET /products/{id} |
| Order | 5003 | Order management | POST /orders, GET /orders, PUT /orders/{id}/status |
| Payment | 5004 | Payment processing | POST /payments, GET /payments/{id}, POST /refund |
| Notification | 5005 | Alerts & emails | POST /notify, GET /notifications |
| User Profile | 5006 | User data | GET /users, POST /users, PUT /users/{id} |

---

## 📊 SLI/SLO (Assignment 2)

| SLI | SLO | Prometheus Query |
|-----|-----|-----------------|
| Availability | ≥ 99% | `avg_over_time(up[30d]) * 100` |
| Latency (p95) | ≤ 200ms | `histogram_quantile(0.95, ...)` |
| Error Rate | ≤ 1% | `sum(rate(5xx[5m])) / sum(rate(all[5m]))` |
| Success Rate | ≥ 99% | `sum(rate(2xx[5m])) / sum(rate(all[5m]))` |

---

## 📈 Monitoring (Assignment 3)

```bash
# Prometheus targets: http://localhost:9090/targets
# Grafana dashboards: http://localhost:3000/dashboards
# Alert rules: monitoring/prometheus/alert_rules.yml
```

---

## 🚨 Incident Response (Assignment 4)

```bash
# Simulate incident (Order Service DB failure)
bash scripts/simulate_incident.sh

# Full postmortem: incident-report/postmortem.md
```

---

## 🏗️ Infrastructure as Code (Assignment 5)

### Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Docker Swarm

```bash
docker swarm init
docker stack deploy -c docker-swarm-compose.yml sre-app
docker stack services sre-app
```

### Kubernetes

```bash
# Start minikube
minikube start

# Build images
eval $(minikube docker-env)
docker-compose build

# Deploy all services
kubectl apply -f kubernetes/configmaps/
kubectl apply -f kubernetes/deployments/
kubectl apply -f kubernetes/services/

# Check status
kubectl get pods
kubectl get services
kubectl get hpa
```

---

## ⚙️ Automation & Capacity Planning (Assignment 6)

```bash
# Ansible deployment
cd ansible
ansible-playbook -i inventory.ini playbook.yml

# Load test
bash scripts/load_test.sh 60   # 60 seconds

# Health check
bash scripts/health_check.sh
```

See `capacity-planning.md` for full analysis.

---

## 📁 Repository Structure

```
sre-project/
├── services/                    # 6 microservices (Flask)
│   ├── auth-service/
│   ├── product-service/
│   ├── order-service/
│   ├── payment-service/
│   ├── notification-service/
│   └── user-profile-service/
├── frontend/                    # Nginx + HTML dashboard
├── docker-compose.yml           # Local development
├── docker-swarm-compose.yml     # Swarm production
├── kubernetes/                  # K8s manifests
│   ├── deployments/
│   ├── services/
│   └── configmaps/
├── terraform/                   # IaC provisioning
├── ansible/                     # Config management
├── monitoring/                  # Prometheus + Grafana
│   ├── prometheus/
│   └── grafana/
├── incident-report/             # Postmortem
├── scripts/                     # Automation scripts
├── slo-definition.md            # SLI/SLO specification
├── capacity-planning.md         # Scaling strategy
└── README.md
```

---

## 📋 Deliverables Checklist

- [x] Microservices source code (6 services)
- [x] Docker Compose orchestration
- [x] Docker Swarm configuration
- [x] Kubernetes manifests (Deployment + Service + HPA)
- [x] Terraform infrastructure provisioning
- [x] Ansible playbook (install + deploy + health check)
- [x] Prometheus monitoring + alert rules
- [x] Grafana dashboards (auto-provisioned)
- [x] SLI/SLO definition document
- [x] Incident simulation script
- [x] Postmortem report
- [x] Capacity planning analysis
- [x] Health check + load test scripts
