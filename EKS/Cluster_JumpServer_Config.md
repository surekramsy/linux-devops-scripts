# EKS Cluster - Jump Server Configuration

## 1) Configure kubectl for EKS Cluster

```bash
aws eks update-kubeconfig --name backend --region ap-south-1
```

Output:

```text
root@ip-10-0-8-169:~# aws eks update-kubeconfig --name backend --region ap-south-1
Added new context arn:aws:eks:ap-south-1:123456789012:cluster/backend to /root/.kube/config
root@ip-10-0-8-169:~#
```

---

## 2) Install eksctl

Documentation:

https://docs.aws.amazon.com/eks/latest/eksctl/installation.html

```bash
# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

# (Optional) Verify checksum
curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

sudo install -m 0755 /tmp/eksctl /usr/local/bin && rm /tmp/eksctl
```

---

## 3) Associate IAM OIDC Provider

```bash
eksctl utils associate-iam-oidc-provider \
--cluster backend \
--approve \
--region=ap-south-1
```

Output:

```text
root@ip-10-0-8-169:~# eksctl utils associate-iam-oidc-provider --cluster backend --approve --region=ap-south-1

2026-03-09 11:06:28 [ℹ]  will create IAM Open ID Connect provider for cluster "backend" in "ap-south-1"
2026-03-09 11:06:28 [✔]  created IAM Open ID Connect provider for cluster "backend" in "ap-south-1"

root@ip-10-0-8-169:~#
```

---

## 4) Create IAM Service Account for AWS Load Balancer Controller

```bash
eksctl create iamserviceaccount \
--cluster=backend \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--attach-policy-arn=arn:aws:iam::123456789012:policy/AWSLoadBalancerControllerIAMPolicy \
--region=ap-south-1 \
--approve
```

Output:

```text
root@ip-10-0-8-169:~# eksctl create iamserviceaccount --cluster=backend --namespace=kube-system --name=aws-load-balancer-controller --attach-policy-arn=arn:aws:iam::123456789012:policy/AWSLoadBalancerControllerIAMPolicy --region=ap-south-1 --approve

2026-03-09 11:15:34 [ℹ]  1 iamserviceaccount (kube-system/aws-load-balancer-controller) was included (based on the include/exclude rules)

2026-03-09 11:15:34 [!]  serviceaccounts that exist in Kubernetes will be excluded, use --override-existing-serviceaccounts to override

2026-03-09 11:15:34 [ℹ]  1 task:
{
    2 sequential sub-tasks:
    {
        create IAM role for serviceaccount "kube-system/aws-load-balancer-controller",
        create serviceaccount "kube-system/aws-load-balancer-controller",
    }
}

2026-03-09 11:15:34 [ℹ]  building iamserviceaccount stack "eksctl-backend-addon-iamserviceaccount-kube-system-aws-load-balancer-controller"

2026-03-09 11:15:34 [ℹ]  deploying stack "eksctl-backend-addon-iamserviceaccount-kube-system-aws-load-balancer-controller"

2026-03-09 11:15:34 [ℹ]  waiting for CloudFormation stack "eksctl-backend-addon-iamserviceaccount-kube-system-aws-load-balancer-controller"

2026-03-09 11:16:04 [ℹ]  waiting for CloudFormation stack "eksctl-backend-addon-iamserviceaccount-kube-system-aws-load-balancer-controller"

2026-03-09 11:16:04 [ℹ]  created serviceaccount "kube-system/aws-load-balancer-controller"

root@ip-10-0-8-169:~#
```

---

## 5) Install Helm

```bash
snap install helm --classic
```

Add EKS Helm Repository:

```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update
```

Output:

```text
root@ip-10-0-8-169:~# helm repo add eks https://aws.github.io/eks-charts

"eks" has been added to your repositories

root@ip-10-0-8-169:~# helm repo update

Hang tight while we grab the latest from your chart repositories...

...Successfully got an update from the "eks" chart repository

Update Complete. ⎈Happy Helming!⎈

root@ip-10-0-8-169:~#
```

---

## 6) Install AWS Load Balancer Controller

```bash
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
-n kube-system \
--set clusterName=backend \
--set serviceAccount.create=false \
--set serviceAccount.name=aws-load-balancer-controller \
--set region=ap-south-1 \
--set vpcId=vpc-06bf1b940da24e945
```

Output:

```text
NAME: aws-load-balancer-controller
LAST DEPLOYED: Mon Mar 9 11:19:53 2026
NAMESPACE: kube-system
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
TEST SUITE: None

NOTES:
AWS Load Balancer controller installed!
```

---

## 7) Rename Kubernetes Context

```bash
kubectl config rename-context arn:aws:eks:ap-south-1:123456789012:cluster/backend backend-prod
```

---

## 8) Attach ECR Repository Permissions

Attach the following ECR repository access to:

* Role: `backend-github-oidc-role`
* Policy: `backend-ecr-access`

ECR Repository ARN:

```text
arn:aws:ecr:ap-south-1:123456789012:repository/tokenborg/explorer
```
