#!/bin/bash
# start-vllm.sh
# Run this inside a RunPod pod to install and start vLLM
# Usage: HF_TOKEN=hf_... bash start-vllm.sh [model-name]

set -e

MODEL=${1:-"mistralai/Mistral-7B-Instruct-v0.2"}
HF_TOKEN=${HF_TOKEN:-$HUGGING_FACE_HUB_TOKEN}

if [ -z "$HF_TOKEN" ]; then
  echo "Error: Set HF_TOKEN or HUGGING_FACE_HUB_TOKEN environment variable"
  exit 1
fi

export HUGGING_FACE_HUB_TOKEN=$HF_TOKEN

echo "Installing vLLM..."
pip install vllm -q

echo "Starting vLLM server for model: $MODEL"
python3 -m vllm.entrypoints.openai.api_server \
  --model "$MODEL" \
  --host 0.0.0.0 \
  --port 8000 \
  --dtype float16 \
  --max-model-len 4096
