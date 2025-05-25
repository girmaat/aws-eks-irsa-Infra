#!/bin/bash

# === CONFIGURATION ===
CLUSTER_NAME="my-eks-cluster"
NAMESPACE="irsa-demo"
SERVICE_ACCOUNT="irsa-sa"
ROLE_NAME="IRSA-Demo-Role"
REGION="us-east-1"

# === RESOLVE ACCOUNT & OIDC INFO ===
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
OIDC_URL=$(aws eks describe-cluster --name $CLUSTER_NAME --region $REGION \
            --query "cluster.identity.oidc.issuer" --output text)
OIDC_HOST=$(echo $OIDC_URL | cut -d/ -f3)

# === FILES ===
TRUST_POLICY_FILE="trust-policy.json"
PERMISSIONS_POLICY_FILE="permissions-policy.json"

# === BUILD DYNAMIC TRUST POLICY ===
cat > $TRUST_POLICY_FILE <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${ACCOUNT_ID}:oidc-provider/${OIDC_HOST}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${OIDC_HOST}:sub": "system:serviceaccount:${NAMESPACE}:${SERVICE_ACCOUNT}"
        }
      }
    }
  ]
}
EOF

echo "✅ Trust policy written to $TRUST_POLICY_FILE"

# === CREATE ROLE ===
echo "🔧 Creating IAM role: $ROLE_NAME"
aws iam create-role \
  --role-name $ROLE_NAME \
  --assume-role-policy-document file://$TRUST_POLICY_FILE \
  --description "IAM Role for IRSA demo in EKS" || {
    echo "⚠️ Role may already exist — continuing..."
  }

# === ATTACH PERMISSIONS POLICY INLINE ===
echo "🔗 Attaching permissions policy to role"
aws iam put-role-policy \
  --role-name $ROLE_NAME \
  --policy-name IRSA-Demo-Permissions \
  --policy-document file://$PERMISSIONS_POLICY_FILE

# === OUTPUT INFO ===
echo "🎉 Done!"
echo "IAM Role ARN: arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME}"
