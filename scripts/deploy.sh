#!/bin/bash

set -euo pipefail

# === CONFIGURATION ===
K8S_DIR="../k8s"

echo "🚀 Deploying IRSA demo resources..."

# 1. Create namespace
echo "🔧 Creating namespace..."
kubectl apply -f "${K8S_DIR}/namespace.yaml"

# 2. Create ServiceAccount (linked to IAM role)
echo "🔐 Creating ServiceAccount..."
kubectl apply -f "${K8S_DIR}/serviceaccount.yaml"

# 3. Create optional RBAC rules (if needed)
if [ -f "${K8S_DIR}/rbac.yaml" ]; then
  echo "🔐 Creating RBAC rules..."
  kubectl apply -f "${K8S_DIR}/rbac.yaml"
fi

# 4. Deploy test pod
echo "📦 Deploying test pod..."
kubectl apply -f "${K8S_DIR}/pod.yaml"

echo "✅ All Kubernetes resources for IRSA demo deployed successfully."
