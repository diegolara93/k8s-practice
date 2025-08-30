#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="k8s-practice"

# 1. Create kind cluster
kind create cluster --name $CLUSTER_NAME || true

# 2. Build + load app image
docker build -t k8s:dev .
kind load docker-image k8s:dev --name $CLUSTER_NAME

# 3. Deploy your app (Deployment + Service)
kubectl apply -f k8s.yaml

# 4. Install Prometheus + Grafana
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring || true
helm upgrade --install kps prometheus-community/kube-prometheus-stack -n monitoring

# 5. Apply ServiceMonitor
kubectl apply -f servicemonitor.yaml

# 6. Start port-forwards in background
chmod +x pf.sh
./pf.sh
