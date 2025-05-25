# 🛡️ EKS IRSA Demo — IAM Roles for Service Accounts

This project demonstrates how to configure and test **IAM Roles for Service Accounts (IRSA)** in **Amazon EKS**, allowing a Kubernetes pod to securely assume an IAM role **without hardcoded AWS credentials**.

---

## 🚀 What This Project Does

- Associates an **OIDC provider** with your EKS cluster
- Creates a restricted **IAM role with trust policy**
- Annotates a Kubernetes **ServiceAccount** with that IAM role
- Deploys a **test pod** that uses IRSA to assume the role
- Verifies the pod identity with **AWS STS**

---

## 🧱 Project Structure

| Directory | Purpose |
|-----------|---------|
| `iam/`     | JSON policies and CLI script to create the IAM role for IRSA |
| `k8s/`     | Kubernetes YAML: namespace, ServiceAccount, pod, RBAC |
| `scripts/` | Automation scripts for deploy, validate, teardown, OIDC |
| `validate/`| Simple STS test call from inside a pod |
| `docs/`    | (Optional) Diagrams, flowcharts, or setup notes |
| `.github/` | GitHub Actions workflow to validate the setup |

---

## 🧪 Quick Start

```bash
cd scripts

# Step 1: Enable OIDC provider on your EKS cluster
./enable-oidc.sh

# Step 2: Create the IAM role and attach policies
cd ../iam
./create-irsa-role.sh

# Step 3: Deploy Kubernetes manifests (ServiceAccount, pod, etc.)
cd ../scripts
./deploy.sh

# Step 4: Validate identity inside the pod
./validate-irsa.sh

# Step 5: Clean up
./destroy.sh


IAM Permissions Granted
This demo allows the pod to:

Write logs to CloudWatch Logs

Read/write objects from S3 buckets

Customize iam/permissions-policy.json for tighter access in production.

Success Output
{
  "UserId": "AROAXXXXEXAMPLE:irsa-sa",
  "Account": "123456789012",
  "Arn": "arn:aws:sts::123456789012:assumed-role/IRSA-Demo-Role/irsa-sa"
}
