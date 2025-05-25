#!/bin/bash

set -euo pipefail

# === CONFIGURATION ===
CLUSTER_NAME="my-eks-cluster"
REGION="us-east-1"

echo "🔍 Checking if OIDC provider is already associated with EKS cluster '${CLUSTER_NAME}'..."

OIDC_URL=$(aws eks describe-cluster \
  --name "$CLUSTER_NAME" \
  --region "$REGION" \
  --query "cluster.identity.oidc.issuer" \
  --output text)

if [[ "$OIDC_URL" == "None" ]]; then
  echo "⚠️  OIDC provider is not enabled. Associating it now..."
  eksctl utils associate-iam-oidc-provider \
    --cluster "$CLUSTER_NAME" \
    --region "$REGION" \
    --approve
else
  echo "✅ OIDC provider is already enabled:"
  echo "$OIDC_URL"
fi
