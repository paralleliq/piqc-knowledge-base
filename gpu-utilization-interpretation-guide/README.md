# GPU Utilization: Interpretation Guide for LLM Inference

GPU utilization is one of the most commonly referenced metrics in ML production — and one of the most frequently misunderstood.

In LLM inference workloads, low or fluctuating GPU utilization does **not** necessarily indicate unused capacity, inefficiency, or the need to scale down. In many cases, it is a symptom of deeper execution-level constraints.

This guide explains:
- what GPU utilization actually measures
- why it is often misleading for LLM inference
- how to correctly interpret GPU utilization alongside other signals
- common failure patterns and how to distinguish them

## When to use this guide

Use this guide if you observe:
- low GPU utilization despite high latency
- flat or declining throughput while GPUs appear “idle”
- confusion about whether to scale up or scale down
- conflicting signals between GPU metrics and user experience

## Key idea

> GPU utilization is an *effect*, not a cause.

Correct interpretation requires correlating utilization with:
- GPU memory pressure
- batching effectiveness
- request concurrency
- runtime configuration (e.g., tensor parallelism)
- serving and orchestration behavior

This guide focuses on **interpretation**, not generic monitoring setup.

