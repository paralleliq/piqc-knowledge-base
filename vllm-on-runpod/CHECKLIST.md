# Checklist: Deploying a HuggingFace Model on vLLM using RunPod

## 1. Prerequisites
- [ ] RunPod account created at runpod.io
- [ ] Credits added to RunPod account ($10 is sufficient for testing)
- [ ] SSH key pair available (`~/.ssh/id_ed25519` or similar)
- [ ] HuggingFace account created

## 2. HuggingFace Setup
- [ ] Create account at huggingface.co
- [ ] Accept model license agreement (for gated models like Mistral)
- [ ] Generate access token at huggingface.co/settings/tokens (read access)
- [ ] Save token securely — you'll need it inside the pod

## 3. RunPod SSH Key Setup
- [ ] Get your public key:
  ```bash
  cat ~/.ssh/id_ed25519.pub
  ```
- [ ] Go to RunPod → Settings → SSH Keys
- [ ] Paste your public key and save
  > Important: Add the key BEFORE creating the pod, otherwise SSH won't work

## 4. Create GPU Pod
- [ ] Click **New Pod** → **Pod**
- [ ] Select template: search for **vLLM** or use **RunPod PyTorch**
- [ ] Select GPU:
  - For Mistral 7B: any GPU with 16GB+ VRAM (RTX 3090, RTX 4090, A10G, L4, A100)
  - Choose based on availability (green = in stock)
- [ ] Set **Container Disk**: minimum **50GB**
  > Default 10GB is not enough — vLLM package alone needs ~5GB
- [ ] Click **Deploy**
- [ ] Wait for pod to reach **Running** state

## 5. SSH Into the Pod
- [ ] Find the SSH command in the pod details (Connect → SSH)
- [ ] Connect:
  ```bash
  ssh <pod-id>@ssh.runpod.io -i ~/.ssh/id_ed25519
  ```
  > If you get "Permission denied": stop the pod, verify SSH key is saved in settings, restart
- [ ] Verify disk space:
  ```bash
  df -h
  ```
  > Should show 50GB available

## 6. Install and Start vLLM
- [ ] Set HuggingFace token:
  ```bash
  export HUGGING_FACE_HUB_TOKEN=hf_your_token_here
  ```
- [ ] Install vLLM:
  ```bash
  pip install vllm
  ```
  > Takes 3-5 minutes
- [ ] Verify installation:
  ```bash
  python3 -c "import vllm; print(vllm.__version__)"
  ```
- [ ] Start vLLM server:
  ```bash
  python3 -m vllm.entrypoints.openai.api_server \
    --model mistralai/Mistral-7B-Instruct-v0.2 \
    --host 0.0.0.0 \
    --port 8000 \
    --dtype float16 \
    --max-model-len 4096
  ```
  > Model downloads from HuggingFace (~14GB) — takes 5-10 minutes
  > Look for: "Application startup complete"

## 7. Verify (Open a Second SSH Session)
- [ ] Health check:
  ```bash
  curl http://localhost:8000/health
  ```
  > Empty response = healthy

- [ ] List models:
  ```bash
  curl -m 10 http://localhost:8000/v1/models
  ```

- [ ] Run inference:
  ```bash
  curl -s http://localhost:8000/v1/chat/completions \
    -H "Content-Type: application/json" \
    -d '{
      "model": "mistralai/Mistral-7B-Instruct-v0.2",
      "messages": [{"role": "user", "content": "What is 2+2?"}],
      "max_tokens": 50
    }'
  ```

- [ ] Check GPU utilization:
  ```bash
  nvidia-smi
  ```

- [ ] Check Prometheus metrics:
  ```bash
  curl -s http://localhost:8000/metrics | grep vllm:kv_cache
  ```

- [ ] Load test (10 concurrent requests):
  ```bash
  for i in {1..10}; do
    curl -s http://localhost:8000/v1/chat/completions \
      -H "Content-Type: application/json" \
      -d '{"model":"mistralai/Mistral-7B-Instruct-v0.2","messages":[{"role":"user","content":"Explain AI in one sentence."}],"max_tokens":100}' &
  done
  wait
  ```

## 8. Cleanup (to avoid charges)
- [ ] Go to RunPod UI
- [ ] **Stop** the pod (pauses GPU billing, small storage charge continues)
- [ ] Or **Terminate** the pod (no charges at all, data is lost)

---

## Common Problems and Solutions

| Problem | Cause | Fix |
|---------|-------|-----|
| SSH Permission denied | Key not registered before pod start | Add key in settings, stop & restart pod |
| No disk space for pip install | Container disk too small | Recreate pod with 50GB disk |
| GPU not available | Low supply in selected tier | Pick different GPU or wait |
| `/v1/models` hangs | vLLM still initializing | Wait for "Application startup complete" |
| `curl` not in container | Some base images lack curl | Use `python3 -c "import urllib..."` instead |
| Model download slow | 14GB weights from HuggingFace | Normal — wait 5-10 minutes |
