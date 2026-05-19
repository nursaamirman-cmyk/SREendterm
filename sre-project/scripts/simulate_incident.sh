#!/bin/bash
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo -e "${RED}INCIDENT SIMULATION: Order Service DB Failure${NC}"
cp docker-compose.yml docker-compose.yml.backup
echo -e "${YELLOW}Injecting fault: DB_HOST=wrong-postgres${NC}"
sed -i 's/DB_HOST=postgres/DB_HOST=wrong-postgres/' docker-compose.yml
docker-compose up -d order-service > /dev/null 2>&1
sleep 5
CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5003/health 2>/dev/null)
echo -e "Order Service status: ${RED}HTTP $CODE — INCIDENT ACTIVE${NC}"
echo "Check Grafana: http://localhost:3000 | Prometheus: http://localhost:9090"
echo "Press ENTER to resolve..."
read -r
cp docker-compose.yml.backup docker-compose.yml
docker-compose up -d order-service > /dev/null 2>&1
sleep 8
CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5003/health 2>/dev/null)
[ "$CODE" = "200" ] && echo -e "${GREEN}INCIDENT RESOLVED — Service restored${NC}" || echo -e "${RED}Still unhealthy: HTTP $CODE${NC}"
rm -f docker-compose.yml.backup
