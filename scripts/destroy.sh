#!/bin/bash

# tear down all Kubernetes resources

set -euo pipefail

NAMESPACE="irsa-demo"

echo "🗑️ Cleaning up IRSA demo namespace: ${NAMESPACE}..."

kubectl delete namespace "${NAMESPACE}" --ignore-not-found

echo "✅ All Kubernetes resources related to IRSA demo have been deleted."
