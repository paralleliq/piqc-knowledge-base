# Symptoms of KV Cache Pressure

KV cache pressure typically appears **before any crash or OOM event**. This degraded state can persist for hours or days before GPU OOM occurs.

### Canonical KV Cache Pressure Pattern ###

Most of the following are true:

- GPU memory steadily rising
- GPU utilization falling
- effective batch size collapses to ~1–2
- p95 / p99 latency rises
- throughput plateaus or declines

This combination is highly indicative of KV cache saturation.

Common indicators include:

### - GPU memory steadily rising under traffic

```bash
kubectl exec <vllm-pod> -- nvidia-smi \
   --query-gpu=memory.used,memory.total \
   --format=csv -l 5
```

or via Prometheus/DCGM:

```bash
avg_over_time(DCGM_FI_DEV_FB_USED[10m])
```

**Interpretation**
A steady upward memory trend under sustained load is a strong early signal of KV cache accumulation.

Memory often continues rising:

- even when throughput flattens
- even when GPU utilization drops

This indicates tokens are being retained in cache faster than they are retired.

### - GPU compute utilization dropping

```bash
kubectl exec <vllm-pod> -- nvidia-smi --query-gpu=utilization.gpu --format=csv -l 5
```

or via Prometheus:

```bash
avg_over_time(DCGM_FI_DEV_GPU_UTIL[10m])
```

**Interpretation**
Memory remains high while compute utilization falls.

This indicates:

- the runtime is memory-bound, not compute-bound
- scheduling and batching are failing due to KV cache pressure

This pattern is highly characteristic of KV cache saturation.

### - Effective batch size (p95) falling to 1–2

From vLLM runtime metrics (/metrics) if available or via Prometheus histogram quantiles if batch-size histograms are exported

Example PromQL pattern:

```bash
histogram_quantile(
  0.95,
  sum(rate(vllm_effective_batch_size_bucket[5m])) by (le)
)
```

**Interpretation**

A p95 effective batch size near 1–2 indicates batching collapse.

At this point:

- continuous batching is no longer effective
- GPU kernels are under-utilized
- tail latency rises rapidly

This is one of the strongest early indicators of KV cache pressure.

### - p95 / p99 latency increasing

```bash
histogram_quantile(
  0.99,
  sum(rate(vllm_request_latency_seconds_bucket[5m])) by (le)
)
```

**Interpretation**
This is often the first externally visible signal.

Latency rises because:

- batching collapses
- requests serialize behind long-lived sequences
- scheduling becomes memory-constrained

Tail latency typically degrades long before OOM.

### - Throughput flattening or decreasing

Tokens/sec stop increasing as traffic rises

Throughput may decline even before an OOM occurs

How to check

```bash
sum(rate(vllm_output_tokens_total[5m]))
```

Or, as a fallback:

```bash
sum(rate(vllm_requests_total[5m]))
```

**Interpretation**
A flat or falling throughput curve under sustained load indicates the system has entered a memory-saturated regime.

At this stage:

- additional traffic no longer increases throughput
- tail latency accelerates
- OOM becomes likely without intervention



