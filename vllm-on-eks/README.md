# mistral-vllm

Deploy Mistral 7B Instruct on Kubernetes using vLLM with an OpenAI-compatible API.

## What This Is

A minimal Docker image and Kubernetes deployment for running
`mistralai/Mistral-7B-Instruct-v0.2` using vLLM's OpenAI-compatible server.

## Requirements

- Kubernetes cluster with GPU node (T4 or better, 16GB+ VRAM)
- HuggingFace account with Mistral access token
- AWS ECR or other container registry

## Quick Start

1. Build and push the image:
   ```bash
   docker build -t <your-registry>/mistral-vllm:latest .
   docker push <your-registry>/mistral-vllm:latest
   ```

2. Create the HF token secret:
   ```bash
   kubectl create secret generic hf-token --from-literal=token=hf_...
   ```

3. Deploy:
   ```bash
   kubectl apply -f deployment.yaml
   ```

4. Test:
   ```bash
   kubectl exec -it <pod> -- curl http://localhost:8000/v1/chat/completions \
     -H "Content-Type: application/json" \
     -d '{"model":"mistralai/Mistral-7B-Instruct-v0.2","messages":[{"role":"user","content":"Hello"}],"max_tokens":50}'
   ```

## GPU Requirements

| Model | VRAM Required | Recommended GPU |
|-------|---------------|-----------------|
| Mistral 7B (float16) | ~14GB | T4 (16GB), L4 (24GB), A10G (24GB) |

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
| `Dockerfile` | vLLM image that downloads model at runtime |
| `Dockerfile.embeddedModel` | Alternative: bake model into image |
| `deployment.yaml` | Kubernetes Deployment + Service manifest |
| `CHECKLIST.md` | Step-by-step deployment checklist |

## Observability

Scan this deployment with [piqc](https://github.com/paralleliq/piqc) to surface
GPU utilization, cost efficiency, and tier fit:

```bash
kubectl apply -f https://raw.githubusercontent.com/paralleliq/piqc/main/deploy/rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/paralleliq/piqc/main/deploy/scan-job.yaml
kubectl logs -f job/piqc-scan -n kube-system
```
