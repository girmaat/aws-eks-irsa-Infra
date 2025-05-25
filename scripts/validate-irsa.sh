# test whether the pod successfully assumes the IAM Role via IRSA by running an AWS STS call inside the pod

#!/bin/bash

set -euo pipefail

NAMESPACE="irsa-demo"
POD_NAME="irsa-demo"

echo "🔍 Checking if pod '${POD_NAME}' is running in namespace '${NAMESPACE}'..."

kubectl get pod -n "${NAMESPACE}" "${POD_NAME}" -o wide

echo
echo "🧪 Running identity check inside the pod..."
kubectl exec -n "${NAMESPACE}" "${POD_NAME}" -- \
  aws sts get-caller-identity
