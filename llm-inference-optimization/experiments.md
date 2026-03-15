# Benchmarking LLM Optimizations

## Experiment 1: Prefix Caching

Goal:
Measure TTFT improvement with prefix caching.

Procedure:
1. Run baseline inference
2. Enable prefix cache
3. Compare TTFT

Metrics:
TTFT
GPU utilization

---

## Experiment 2: FlashAttention

Goal:
Measure prefill throughput.

Metrics:
prompt tokens/sec
prefill latency

---

## Experiment 3: Continuous Batching

Goal:
Measure throughput under concurrent load.

Metrics:
tokens/sec
active sequences/GPU
