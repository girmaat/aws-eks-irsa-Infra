# 📂 Kubernetes Manifests for IRSA Demo

This directory contains all Kubernetes YAML files needed to demonstrate how to securely access AWS services from inside an EKS cluster using **IRSA (IAM Roles for Service Accounts)**.

---

## What’s Included

| File | Purpose |
|------|---------|
| `namespace.yaml`       | Creates a dedicated namespace (`irsa-demo`) to keep test workloads isolated |
| `serviceaccount.yaml`  | Defines a Kubernetes ServiceAccount annotated with an IAM Role ARN for IRSA |
| `pod.yaml`             | Launches a test pod that uses the ServiceAccount to call `aws sts get-caller-identity` |
| `rbac.yaml` *(optional)* | Adds RBAC rules to allow the pod to query the Kubernetes API (e.g. `get pods`) |

---

## Setup Instructions

1. **Create Namespace**

```bash
kubectl apply -f namespace.yaml
```

2. **Create ServiceAccount (linked to IAM role)**

```bash
kubectl apply -f serviceaccount.yaml
```

3. **Deploy the Test Pod**

```bash
kubectl apply -f pod.yaml
```

4. **(Optional) Apply RBAC for Kubernetes API Access**

```bash
kubectl apply -f rbac.yaml
```

---

## Test: Verify IRSA is Working

Once the pod is running:

```bash
kubectl exec -it -n irsa-demo irsa-demo -- \
  aws sts get-caller-identity
```

You should see an output like:

```json
{
  "UserId": "AROAXXXXXXXXXXXXXXXX:irsa-sa",
  "Account": "123456789012",
  "Arn": "arn:aws:sts::123456789012:assumed-role/IRSA-Demo-Role/irsa-sa"
}
```

This confirms that your pod has **successfully assumed the IAM role via IRSA**, using the ServiceAccount you defined.

---

## Clean Up

To remove all demo resources:

```bash
kubectl delete namespace irsa-demo
```

---

## Notes

- You must first create the IAM Role via the `/iam` setup scripts
- Be sure the ServiceAccount’s annotation contains the correct **role ARN**
- This test pod uses Amazon Linux 2 with AWS CLI for demonstration

---

## Next Step

Go to the [`scripts/`](../scripts) folder to find:
- A one-liner deployment script
- A validation script that automates the identity test
