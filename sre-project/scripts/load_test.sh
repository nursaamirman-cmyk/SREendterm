#!/bin/bash
DURATION=${1:-60}
echo "Load test: ${DURATION}s | Start: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
ENDPOINTS=("http://localhost:5001/health" "http://localhost:5002/products" "http://localhost:5003/orders" "http://localhost:5006/users")
START=$(date +%s); SUCCESS=0; FAIL=0
while [ $(($(date +%s) - START)) -lt $DURATION ]; do
  for URL in "${ENDPOINTS[@]}"; do
    CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 "$URL")
    if [[ "$CODE" =~ ^2 ]]; then ((SUCCESS++)); else ((FAIL++)); fi
  done
  sleep 0.2
done
TOTAL=$((SUCCESS + FAIL))
echo "Total: $TOTAL | Success: $SUCCESS | Failed: $FAIL"
echo "Success rate: $(echo "scale=1; $SUCCESS * 100 / $TOTAL" | bc)%"
