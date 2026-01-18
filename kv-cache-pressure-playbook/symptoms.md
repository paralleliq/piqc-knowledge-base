# Symptoms of KV Cache Pressure

KV cache pressure typically appears before any crash or OOM event.  This degraded state can persist for hours or days before GPU OOM occurs.

Common indicators include:

### - GPU memory steadily rising under traffic

kubectl exec \<vllm-pod\> -- nvidia-smi --query-gpu=memory.used,memory.total --format=csv -l 5

or via Prometheus/DCGM:

avg_over_time(DCGM_FI_DEV_FB_USED[10m])

A steady upward trend under sustained load is a strong early signal.

### - GPU compute utilization dropping

kubectl exec \<vllm-pod\> -- nvidia-smi --query-gpu=utilization.gpu --format=csv -l 5

or via Prometheus:

avg_over_time(DCGM_FI_DEV_GPU_UTIL[10m])

This pattern indicates the runtime is memory-bound, not compute-bound.

### - Effective batch size (p95) falling to 1–2

From vLLM runtime metrics (/metrics) if available

Or via Prometheus histogram quantiles if batch-size histograms are exported

Example PromQL pattern:

histogram_quantile(
  0.95,
  sum(rate(vllm_effective_batch_size_bucket[5m])) by (le)
)


A p95 near 1–2 is a strong signal of batching collapse.

### - p95 / p99 latency increasing

histogram_quantile(
  0.99,
  sum(rate(vllm_request_latency_seconds_bucket[5m])) by (le)
)

This is often the first user-visible symptom.

### - Throughput flattening or decreasing

Tokens/sec stop increasing as traffic rises

Throughput may decline even before an OOM occurs

How to check

sum(rate(vllm_output_tokens_total[5m]))


Or, as a fallback:

sum(rate(vllm_requests_total[5m]))

A flat or falling throughput curve under sustained load is a late-stage warning.



