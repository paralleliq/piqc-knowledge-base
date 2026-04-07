# Checklist: Deploying a HuggingFace Model on vLLM using GKE

## 1. Prerequisites
- [ ] Google Cloud account with billing enabled
- [ ] `gcloud` CLI installed: https://cloud.google.com/sdk/docs/install
- [ ] `kubectl` installed
- [ ] HuggingFace account created

## 2. HuggingFace Setup
- [ ] Create account at huggingface.co
- [ ] Accept model license agreement (for gated models like Mistral)
- [ ] Generate access token at huggingface.co/settings/tokens (read access)
- [ ] Save token securely — you'll need it later

## 3. GCP Project Setup
- [ ] Create or select a GCP project
- [ ] Enable billing
- [ ] Enable required APIs:
  ```bash
  gcloud services enable container.googleapis.com compute.googleapis.com
  ```
- [ ] Authenticate:
  ```bash
  gcloud auth login
  gcloud config set project <your-project-id>
  ```
- [ ] Check GPU quota (Compute Engine → IAM & Admin → Quotas → search "GPU"):
  - If quota is 0, request an increase before proceeding

## 4. Create GKE Cluster with GPU Node
- [ ] Create cluster (try multiple zones if you get stockout errors):
  ```bash
  gcloud container clusters create vllm-demo \
    --zone us-central1-a \
    --num-nodes 1 \
    --machine-type g2-standard-4 \
    --accelerator type=nvidia-l4,count=1 \
    --no-enable-autoupgrade
  ```
  > If you get stockout errors, try: `us-central1-b`, `us-east1-b`, or switch to T4:
  > `--machine-type n1-standard-4 --accelerator type=nvidia-tesla-t4,count=1`

- [ ] Get credentials:
  ```bash
  gcloud container clusters get-credentials vllm-demo --zone us-central1-a
  ```
- [ ] Verify node is ready:
  ```bash
  kubectl get nodes
  kubectl describe node <node-name> | grep -A10 "Allocatable"
  ```
- [ ] Confirm `nvidia.com/gpu: 1` appears in allocatable resources
- [ ] Install NVIDIA device plugin:
  ```bash
  kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.14.0/nvidia-device-plugin.yml
  ```

## 5. Deploy vLLM
- [ ] Create HuggingFace token secret:
  ```bash
  kubectl create secret generic hf-token \
    --from-literal=token=hf_your_token_here
  ```
- [ ] Apply deployment manifest:
  ```bash
  kubectl apply -f deployment.yaml
  ```
- [ ] Watch pod come up:
  ```bash
  kubectl get pods -w
  ```
  > Pod will go: Pending → ContainerCreating → Running
  > Image pull (~33GB): 5-10 minutes
  > Model download (~14GB): 5-10 minutes

- [ ] Check logs to confirm startup:
  ```bash
  kubectl logs -f deployment/mistral-7b
  ```
  > Look for: "Application startup complete"

## 6. Verify
- [ ] Health check:
  ```bash
  kubectl exec -it <pod-name> -- curl http://localhost:8000/health
  ```
  > Empty response = healthy (200 OK)

- [ ] List models:
  ```bash
  kubectl exec -it <pod-name> -- curl -s http://localhost:8000/v1/models
  ```
  > Should return JSON with model ID

- [ ] Run inference:
  ```bash
  kubectl exec -it <pod-name> -- curl -s http://localhost:8000/v1/chat/completions \
    -H "Content-Type: application/json" \
    -d '{
      "model": "mistralai/Mistral-7B-Instruct-v0.2",
      "messages": [{"role": "user", "content": "What is 2+2?"}],
      "max_tokens": 50
    }'
  ```

- [ ] Check Prometheus metrics:
  ```bash
  kubectl exec -it <pod-name> -- curl -s http://localhost:8000/metrics | grep vllm:kv_cache
  ```

## 7. Cleanup (to avoid charges)
- [ ] Delete the cluster:
  ```bash
  gcloud container clusters delete vllm-demo --zone us-central1-a --quiet
  ```
- [ ] Verify no instances running:
  ```bash
  gcloud compute instances list
  gcloud container clusters list
  ```
  > Both should return empty

---

## Common Problems and Solutions

| Problem | Cause | Fix |
|---------|-------|-----|
| GPU stockout | No L4/T4 capacity in zone | Try different zone or GPU type |
| `nvidia.com/gpu` not allocatable | NVIDIA device plugin missing | Apply device plugin manifest |
| Pod stuck Pending | No GPU nodes or quota | Check node status and GCP quota |
| Image pull slow | 33GB vLLM base image | Normal — wait 10 min |
| Model download slow | 14GB model weights | Normal — wait 5-10 min |
| `/health` returns nothing | Healthy — 200 with empty body | This is correct behavior |
| `nvidia-smi` not found in pod | Not in vLLM container | Use `/metrics` endpoint instead |
| Cloud Shell auth issues | Wrong account | Run `gcloud auth login` |
