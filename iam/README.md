#  IAM — IRSA Role & Policy Configuration

This directory contains the IAM resources required to enable **IRSA (IAM Roles for Service Accounts)** in Amazon EKS. The goal is to allow a Kubernetes pod to securely assume an AWS IAM role via **OIDC identity federation**, without needing static credentials.

---

##  What This Folder Contains

| File | Purpose |
|------|---------|
| `trust-policy.json`         | IAM **trust policy** — defines who is allowed to assume the role (created dynamically by script) |
| `permissions-policy.json`   | IAM **permissions policy** — defines what the role is allowed to do (CloudWatch + S3 access) |
| `create-irsa-role.sh`       | Shell script that automates creation of the IAM role and attaches the policies |

---

## 🧩 How the Pieces Fit Together

When a Kubernetes pod uses a ServiceAccount annotated with an IAM Role ARN, the following chain of trust is required:

1. **IAM Role** must trust your **EKS OIDC provider**.
2. IAM Role must **only trust specific ServiceAccounts** (via `sub` claim).
3. IAM Role must have the **right permissions** attached (to access S3, CloudWatch, etc.).
4. Pod assumes the role **automatically** using IRSA and receives **temporary credentials** via AWS STS.

This directory sets up **steps 1–3**.

---

##  How to Use This

###  1. Configure Your Environment

In `create-irsa-role.sh`, set these values:

```bash
CLUSTER_NAME="my-eks-cluster"
NAMESPACE="irsa-demo"
SERVICE_ACCOUNT="irsa-sa"
ROLE_NAME="IRSA-Demo-Role"
REGION="us-east-1"

Run the Script
chmod +x create-irsa-role.sh
./create-irsa-role.sh

To delete the IAM role/policy:
aws iam delete-role-policy \
  --role-name IRSA-Demo-Role \
  --policy-name IRSA-Demo-Permissions

aws iam delete-role \
  --role-name IRSA-Demo-Role
