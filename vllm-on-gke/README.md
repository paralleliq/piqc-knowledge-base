# vllm-on-gke

Deploy a HuggingFace model on Kubernetes using vLLM on Google Kubernetes Engine (GKE) with an OpenAI-compatible API.

## What This Is

A minimal Kubernetes deployment for running vLLM on GKE using the public
`vllm/vllm-openai` image. The model is downloaded from HuggingFace at startup —
no custom Docker build required.

## Requirements

- Google Cloud account with billing enabled
- `gcloud` CLI installed and authenticated
- `kubectl` installed
- HuggingFace account with model access token
- GPU quota available in your GCP project

## Quick Start

1. Create GKE cluster with GPU node:
   ```bash
   gcloud container clusters create vllm-demo \
     --zone us-central1-a \
     --num-nodes 1 \
     --machine-type g2-standard-4 \
     --accelerator type=nvidia-l4,count=1 \
     --no-enable-autoupgrade
   ```

2. Get credentials:
   ```bash
   gcloud container clusters get-credentials vllm-demo --zone us-central1-a
   ```

3. Install NVIDIA device plugin:
   ```bash
   kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v0.14.0/nvidia-device-plugin.yml
   ```

4. Create HuggingFace token secret:
   ```bash
   kubectl create secret generic hf-token --from-literal=token=hf_your_token_here
   ```

5. Deploy:
   ```bash
   kubectl apply -f deployment.yaml
   ```

6. Watch pod come up (image pull + model download takes ~10-15 min):
   ```bash
   kubectl get pods -w
   ```

7. Test inference:
   ```bash
   kubectl exec -it <pod-name> -- curl -s http://localhost:8000/v1/chat/completions \
     -H "Content-Type: application/json" \
     -d '{
       "model": "mistralai/Mistral-7B-Instruct-v0.2",
       "messages": [{"role": "user", "content": "What is 2+2?"}],
       "max_tokens": 50
     }'
   ```

## GPU Options on GKE

| Machine Type | GPU | VRAM | Good For |
|-------------|-----|------|----------|
| `g2-standard-4` | NVIDIA L4 | 24GB | 7B-13B models |
| `a2-highgpu-1g` | NVIDIA A100 | 40GB | 13B-70B models |
| `n1-standard-4` + T4 | NVIDIA T4 | 16GB | 7B models (cheaper) |

## API Endpoints

| Endpoint | Description |
|----------|-------------|
| `GET /health` | Health check |
| `GET /v1/models` | List loaded models |
| `POST /v1/chat/completions` | OpenAI-compatible chat |
| `GET /metrics` | Prometheus metrics |

## Files

| File | Description |
|------|-------------|
| `deployment.yaml` | Kubernetes Deployment + Service manifest |
| `CHECKLIST.md` | Step-by-step deployment checklist |

## Cleanup

```bash
gcloud container clusters delete vllm-demo --zone us-central1-a --quiet
```

## Observability

Scan this deployment with [piqc](https://github.com/paralleliq/piqc) to surface
GPU utilization, cost efficiency, and tier fit:

```bash
kubectl apply -f https://raw.githubusercontent.com/paralleliq/piqc/main/deploy/rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/paralleliq/piqc/main/deploy/scan-job.yaml
kubectl logs -f job/piqc-scan -n kube-system
```
