#!/bin/bash
GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'; BOLD='\033[1m'
echo -e "${BOLD}SRE Microservices — Health Check${NC}"
echo "Timestamp: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
echo "─────────────────────────────────────"
SERVICES=("Auth:http://localhost:5001/health" "Product:http://localhost:5002/health" "Order:http://localhost:5003/health" "Payment:http://localhost:5004/health" "Notification:http://localhost:5005/health" "UserProfile:http://localhost:5006/health" "Prometheus:http://localhost:9090/-/healthy" "Grafana:http://localhost:3000/api/health")
HEALTHY=0; UNHEALTHY=0
for entry in "${SERVICES[@]}"; do
  NAME="${entry%%:*}"; URL="${entry#*:}"
  CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 --max-time 5 "$URL" 2>/dev/null)
  if [ "$CODE" = "200" ]; then
    echo -e "  ${GREEN}✓${NC} $NAME — HEALTHY (HTTP $CODE)"; ((HEALTHY++))
  else
    echo -e "  ${RED}✗${NC} $NAME — UNHEALTHY (HTTP $CODE)"; ((UNHEALTHY++))
  fi
done
echo "─────────────────────────────────────"
echo -e "Healthy: ${GREEN}$HEALTHY${NC} | Unhealthy: ${RED}$UNHEALTHY${NC}"
[ $UNHEALTHY -eq 0 ] && exit 0 || exit 1
