# Checklist: Deploying a HuggingFace Model on vLLM using AWS EKS

## 1. Prerequisites
- [ ] AWS CLI installed and configured (`aws configure`)
- [ ] Docker Desktop installed and running
- [ ] kubectl installed
- [ ] eksctl installed (optional but helpful)
- [ ] HuggingFace account created

## 2. HuggingFace Setup
- [ ] Create account at huggingface.co
- [ ] Accept model license agreement (for gated models like Mistral)
- [ ] Generate access token at huggingface.co/settings/tokens (read access)
- [ ] Save token securely — you'll need it later

## 3. AWS Account Setup
- [ ] Create AWS account
- [ ] Configure AWS CLI: `aws configure`
- [ ] Request GPU quota increase for your region:
  ```bash
  aws service-quotas request-service-quota-increase \
    --service-code ec2 \
    --quota-code L-DB2E81BA \
    --desired-value 4 \
    --region us-east-2
  ```
- [ ] Wait for approval (can take hours to 1 business day — new accounts often get denied, appeal with use case details)

## 4. EKS Cluster Setup
- [ ] Create EKS cluster (via console or CLI)
- [ ] Add GPU node group:
  - AMI: `Amazon Linux 2023 (x86_64) Nvidia (AL2023_x86_64_NVIDIA)`
  - Instance type: `g4dn.xlarge` (1x T4, 16GB VRAM) — good for 7B models in float16
  - Disk: 100GB minimum
  - Scaling: min 1, desired 1, max 1
- [ ] Get credentials: `aws eks update-kubeconfig --name <cluster-name> --region <region>`
- [ ] Verify GPU node is ready: `kubectl get nodes`
- [ ] Verify GPU allocatable: `kubectl describe node <node> | grep -A10 Allocatable`
- [ ] Install NVIDIA device plugin:
  ```bash
  kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.14.0/nvidia-device-plugin.yml
  ```
- [ ] Confirm `nvidia.com/gpu: 1` appears in allocatable resources

## 5. Build and Push Docker Image
- [ ] Create Dockerfile:
  ```dockerfile
  FROM vllm/vllm-openai:latest
  EXPOSE 8000
  CMD ["python3", "-m", "vllm.entrypoints.openai.api_server", \
       "--model", "mistralai/Mistral-7B-Instruct-v0.2", \
       "--host", "0.0.0.0", \
       "--port", "8000", \
       "--tensor-parallel-size", "1", \
       "--dtype", "float16", \
       "--max-model-len", "4096"]
  ```
- [ ] Create Amazon ECR repository:
  ```bash
  aws ecr create-repository --repository-name mistral-vllm --region us-east-2
  ```
- [ ] Authenticate Docker to ECR:
  ```bash
  aws ecr get-login-password --region us-east-2 | docker login \
    --username AWS \
    --password-stdin <account-id>.dkr.ecr.us-east-2.amazonaws.com
  ```
- [ ] Build image:
  ```bash
  docker buildx build --platform linux/amd64 \
    -t <account-id>.dkr.ecr.us-east-2.amazonaws.com/mistral-vllm:latest \
    --push .
  ```
  > Note: The vLLM base image is ~33GB. Build and push will take 20-40 minutes.

## 6. Deploy to Kubernetes
- [ ] Create HuggingFace token secret:
  ```bash
  kubectl create secret generic hf-token \
    --from-literal=token=hf_your_token_here
  ```
- [ ] Apply deployment manifest (see deployment.yaml)
- [ ] Watch pod come up: `kubectl get pods -w`
- [ ] Wait for model download (~14GB, 5-10 minutes)
- [ ] Check logs: `kubectl logs -f deployment/mistral-7b`

## 7. Verify
- [ ] Health check: `kubectl exec -it <pod> -- curl http://localhost:8000/health`
- [ ] List models: `kubectl exec -it <pod> -- curl http://localhost:8000/v1/models`
- [ ] Run inference:
  ```bash
  kubectl exec -it <pod> -- curl -s http://localhost:8000/v1/chat/completions \
    -H "Content-Type: application/json" \
    -d '{
      "model": "mistralai/Mistral-7B-Instruct-v0.2",
      "messages": [{"role": "user", "content": "What is 2+2?"}],
      "max_tokens": 50
    }'
  ```
- [ ] Check GPU utilization: `kubectl exec -it <pod> -- nvidia-smi`
- [ ] Check Prometheus metrics: `kubectl exec -it <pod> -- curl http://localhost:8000/metrics`

## 8. Cleanup (to avoid charges)
- [ ] Delete EKS node groups first
- [ ] Delete EKS cluster:
  ```bash
  aws eks delete-cluster --name <cluster-name> --region <region>
  ```
- [ ] Delete ECR repository if no longer needed
- [ ] Verify no EC2 instances running: AWS Console → EC2 → Instances
- [ ] Verify cluster deleted: `aws eks list-clusters --region <region>`

---

## Common Problems and Solutions

| Problem | Cause | Fix |
|---------|-------|-----|
| GPU quota 0 | New AWS account | Request increase, appeal with use case |
| GPU stockout | No capacity in zone | Try different zone or GPU type |
| `nvidia.com/gpu` not in allocatable | NVIDIA device plugin missing | Apply device plugin manifest |
| Pod stuck Pending | No GPU nodes available | Check node group status |
| Image pull slow | 33GB vLLM base image | Normal — wait 20-40 min |
| Model download slow | 14GB model weights | Normal — wait 5-10 min |
| nvidia-smi not found | Not in vLLM container PATH | Use `/metrics` endpoint instead |
| ECR 403 Forbidden | Docker not authenticated | Re-run ECR login command |
