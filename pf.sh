# pf.sh
#!/usr/bin/env bash
set -euo pipefail

# kill background port-forwards on exit
cleanup() { pkill -P $$ || true; }
trap cleanup EXIT

# app (default ns)
kubectl port-forward svc/k8s-svc 8080:80 >/dev/null 2>&1 &

# prometheus & grafana (monitoring ns)
kubectl -n monitoring port-forward svc/kps-prometheus 9090:9090 >/dev/null 2>&1 &
kubectl -n monitoring port-forward svc/kps-grafana     3000:80   >/dev/null 2>&1 &

echo "Forwarding: app http://localhost:8080, Prometheus http://localhost:9090, Grafana http://localhost:3000"
echo "Press Ctrl+C to stop."
wait
