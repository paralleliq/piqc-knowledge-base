# Diagnostics: Understanding GPU Utilization in LLM Inference

This page provides a practical workflow for diagnosing GPU utilization patterns in production LLM inference systems.

---

## 1) Confirm what GPU utilization you are observing

GPU utilization reported by tools like `nvidia-smi` or DCGM reflects:
- percentage of time the GPU compute engines are active

It does **not** measure:
- tokens/sec
- batching efficiency
- memory pressure
- queue depth
- end-user latency

---

## 2) Collect the minimal diagnostic signals

You should always observe GPU utilization together with:

### GPU-level signals

kubectl exec \<vllm-pod\> -- nvidia-smi \
  --query-gpu=utilization.gpu,memory.used,memory.total \
  --format=csv -l 5

Look for:

> memory steadily rising

> utilization fluctuating or declining under load

> Runtime-level signals (vLLM)

If the metrics endpoint is exposed:

kubectl port-forward pod/\<vllm-pod\> 8000:8000
curl -s localhost:8000/metrics | grep -iE "token|batch|latency|running|queue"


Key signals:

> effective batch size (p95)

> tokens/sec

> running sequences

> queue depth

> Request-level signals

From Prometheus (example patterns):

histogram_quantile(
  0.95,
  sum(rate(vllm_request_latency_seconds_bucket[5m])) by (le)
)

sum(rate(vllm_output_tokens_total[5m]))

## 3) Correlate, don’t isolate

GPU utilization alone is not actionable.

Always ask:

> Is GPU memory high or low?

> Is batching effective?

> Is throughput increasing with traffic?

> Are requests queued?

The answers determine whether low utilization is a problem — or expected behavior.

## Check for MIG mode

Before interpreting GPU utilization, confirm whether MIG is enabled.

kubectl exec \<vllm-pod\> -- nvidia-smi -L

If MIG is enabled, you will see output similar to:

GPU 0: A100-SXM4-80GB
  MIG 1g.10gb Device 0
  MIG 1g.10gb Device 1

In this case:

> utilization and memory are per MIG device

> KV cache pressure can occur much earlier

> batch sizes that work on full GPUs may collapse
