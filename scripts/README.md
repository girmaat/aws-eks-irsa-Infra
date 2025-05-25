
# Scripts — IRSA Demo Automation

This directory contains automation scripts for deploying, validating, and tearing down the IRSA demo environment in Amazon EKS.

These scripts assume:
- You have a working EKS cluster
- The cluster has `kubectl` and `aws` CLI access
- You’ve already created the required IAM Role using the `/iam` folder

---

## Available Scripts

| Script | Purpose |
|--------|---------|
| `enable-oidc.sh`       | Ensures your EKS cluster is linked to an OIDC provider (required for IRSA) |
| `deploy.sh`            | Applies all Kubernetes manifests (namespace, SA, RBAC, pod) |
| `validate-irsa.sh`     | Enters the pod and runs `aws sts get-caller-identity` to verify IRSA is working |
| `destroy.sh`           | Cleans up all resources by deleting the `irsa-demo` namespace |

---

## Typical Workflow

```bash
# Step 1: Associate OIDC provider if not already set
./enable-oidc.sh

# Step 2: Deploy K8s resources (namespace, SA, pod, RBAC)
./deploy.sh

# Step 3: Verify IAM Role was assumed via IRSA
./validate-irsa.sh

# Step 4: Clean up everything
./destroy.sh
