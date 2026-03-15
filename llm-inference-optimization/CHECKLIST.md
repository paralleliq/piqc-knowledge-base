# LLM Inference Optimization Checklist

Use this checklist when optimizing an STT → LLM → TTS pipeline.

---

# 1. Prefill Optimization (TTFT)

### Prompt Size

- [ ] Measure average prompt token length
- [ ] Track prompt length distribution (p50/p95/p99)
- [ ] Remove unnecessary prompt content

### Prefix Caching

- [ ] Enable prefix caching in the inference runtime
- [ ] Keep system prompts stable across requests
- [ ] Separate static prompt prefix from dynamic user content
- [ ] Monitor prefix cache hit rate

### Session KV Reuse

- [ ] Preserve KV cache across conversation turns
- [ ] Maintain session affinity to the same GPU
- [ ] Monitor KV cache growth per session

### Context Reduction

- [ ] Limit conversation history
- [ ] Apply conversation summarization
- [ ] Remove redundant prompt instructions

### Retrieval Optimization (RAG)

- [ ] Limit number of retrieved documents
- [ ] Rank retrieved chunks by relevance
- [ ] Compress long document chunks

### FlashAttention

- [ ] Use FlashAttention-enabled inference runtime
- [ ] Verify FlashAttention kernel usage in profiling
- [ ] Benchmark prefill latency with long prompts

---

# 2. Decode Optimization (Tokens/sec)

### KV Cache Efficiency

- [ ] Monitor KV cache memory usage
- [ ] Implement paged KV cache
- [ ] Optimize KV tensor layout

### KV Cache Quantization

- [ ] Evaluate INT8 KV cache
- [ ] Measure impact on decode throughput
- [ ] Monitor accuracy degradation

### Continuous Batching

- [ ] Enable dynamic request batching
- [ ] Track active sequences per GPU
- [ ] Monitor decode batch size distribution

### Speculative Decoding

- [ ] Evaluate draft model compatibility
- [ ] Measure acceptance rate
- [ ] Benchmark tokens/sec improvement

---

# 3. Model Optimization

### Quantization

- [ ] Evaluate FP16 vs INT8 vs INT4
- [ ] Measure tokens/sec improvement
- [ ] Validate accuracy impact

### Efficient Attention

- [ ] Use models with GQA or MQA
- [ ] Evaluate sliding window attention for long contexts

### Model Size

- [ ] Evaluate smaller or distilled models
- [ ] Compare latency vs accuracy tradeoffs

---

# 4. Serving System Optimization

### Request Scheduling

- [ ] Prioritize latency-sensitive requests
- [ ] Implement fair scheduling across sessions

### Session Affinity

- [ ] Route session requests to the same GPU
- [ ] Preserve KV cache across turns

### Load Balancing

- [ ] Balance requests across GPU nodes
- [ ] Avoid GPU hotspots

### Memory Management

- [ ] Implement GPU memory pooling
- [ ] Monitor memory fragmentation

---

# 5. Hardware Optimization

### GPU Selection

- [ ] Use GPUs with high memory bandwidth
- [ ] Evaluate H100 vs A100 vs L40S

### GPU Interconnect

- [ ] Use NVLink or high-speed interconnects
- [ ] Optimize multi-GPU communication

### NUMA Awareness

- [ ] Align CPU/GPU memory locality
- [ ] Minimize cross-socket traffic

---

# 6. Observability

Track the following metrics continuously.

- [ ] TTFT
- [ ] Tokens/sec
- [ ] Inter-token latency
- [ ] GPU utilization
- [ ] Memory bandwidth utilization
- [ ] KV cache size
- [ ] Active sequences per GPU

---

# 7. Voice Pipeline Considerations

### Streaming

- [ ] Stream tokens to TTS as soon as possible
- [ ] Avoid waiting for full response

### Response Length

- [ ] Limit maximum generated tokens
- [ ] Prefer concise responses

### Turn Latency

- [ ] Measure full STT → LLM → TTS latency
- [ ] Target < 1 second turn response when possible
