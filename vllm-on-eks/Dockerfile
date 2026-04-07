FROM vllm/vllm-openai:latest

EXPOSE 8000

CMD ["python3", "-m", "vllm.entrypoints.openai.api_server", \
     "--model", "mistralai/Mistral-7B-Instruct-v0.2", \
     "--host", "0.0.0.0", \
     "--port", "8000", \
     "--tensor-parallel-size", "1", \
     "--dtype", "float16", \
     "--max-model-len", "4096"]

