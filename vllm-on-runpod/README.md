# vllm-on-runpod

Deploy a HuggingFace model on vLLM using RunPod — no Kubernetes, no Docker build required.

## What This Is

A guide for running vLLM inference on a RunPod GPU pod. RunPod provides
on-demand GPU instances by the hour. This approach is ideal for:
- Quick experimentation
- Demos and testing
- Evaluating models before committing to a Kubernetes deployment

## Requirements

- RunPod account with credits (runpod.io)
- HuggingFace account with model access token
- SSH key pair (for pod access)

## Quick Start

1. Create a RunPod account and add credits
2. Add your SSH public key in RunPod Settings → SSH Keys
3. Create a new Pod:
   - Click **New Pod** → **Pod**
   - Search for **vLLM** template (or use PyTorch base)
   - Select a GPU with sufficient VRAM (see table below)
   - Set container disk to **50GB minimum**
4. SSH into the pod:
   ```bash
   ssh <pod-id>@ssh.runpod.io -i ~/.ssh/id_ed25519
   ```
5. Set your HuggingFace token and start vLLM:
   ```bash
   export HUGGING_FACE_HUB_TOKEN=hf_your_token_here
   pip install vllm
   python3 -m vllm.entrypoints.openai.api_server \
     --model mistralai/Mistral-7B-Instruct-v0.2 \
     --host 0.0.0.0 \
     --port 8000 \
     --dtype float16 \
     --max-model-len 4096
   ```
6. In a second SSH session, test inference:
   ```bash
   curl -s http://localhost:8000/v1/chat/completions \
     -H "Content-Type: application/json" \
     -d '{
       "model": "mistralai/Mistral-7B-Instruct-v0.2",
       "messages": [{"role": "user", "content": "What is 2+2?"}],
       "max_tokens": 50
     }'
   ```

## GPU Requirements

| Model | VRAM Required | Recommended GPU |
|-------|---------------|-----------------|
| Mistral 7B (float16) | ~14GB | RTX 3090/4090 (24GB), A10G (24GB) |
| Llama 13B (float16) | ~26GB | A100 (40GB), A40 (48GB) |
| Llama 70B (float16) | ~140GB | 2x A100 80GB |

## API Endpoints

| Endpoint | Description |
|----------|-------------|
| `GET /health` | Health check |
| `GET /v1/models` | List loaded models |
| `POST /v1/chat/completions` | OpenAI-compatible chat |
| `GET /metrics` | Prometheus metrics |

## Pod vs Serverless

| | Pod | Serverless |
|--|-----|------------|
| Access | SSH + direct HTTP | HTTP API only |
| Scaling | Manual | Auto (0 to N) |
| Cold start | None (always on) | ~30-60s when idle |
| Cost | Pay by hour | Pay per request |
| `/metrics` | Direct access | Not exposed |

Use **Pod** for development and testing. Use **Serverless** for production APIs
with bursty traffic.

## Cleanup

Stop or terminate the pod in the RunPod UI when done to stop being charged.
Stopped pods do not incur GPU charges but may incur small storage charges.
Terminated pods incur no charges.

## Files

| File | Description |
|------|-------------|
| `CHECKLIST.md` | Step-by-step deployment checklist |
| `start-vllm.sh` | Convenience script to install and start vLLM |
