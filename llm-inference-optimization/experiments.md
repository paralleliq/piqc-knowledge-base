# Benchmarking LLM Optimizations

This document provides simple experiments to evaluate the impact of common LLM inference optimizations.

## Suggested Environment

Example setup:

- GPU: A100 or H100
- Runtime: vLLM / TensorRT-LLM / TGI
- Model: 7B–13B parameter model
- Prompt length: ~1000–2000 tokens

## Key Metrics

Track the following metrics during experiments:

| Metric | Description |
|------|-------------|
| TTFT | Time to first token |
| tokens/sec | Decode throughput |
| inter-token latency | Time between generated tokens |
| GPU utilization | Compute efficiency |
| active sequences/GPU | Concurrency handled per GPU |

---

# Experiment 1 — Prefix Caching

## Goal

Measure the reduction in **TTFT** when prompt prefixes are reused.

## Workload

Use prompts with a shared prefix such as:

System instructions
Tool definitions
Conversation template
User message

Prefix length: **500–1000 tokens**

## Procedure

1. Run inference with prefix caching **disabled**.
2. Send multiple requests with the same prompt prefix.
3. Record TTFT for each request.
4. Enable prefix caching.
5. Repeat the same requests.
6. Compare TTFT results.

## Metrics

- TTFT
- GPU utilization
- Prefill latency

## Expected Result

Prefix caching should reduce **prefill computation**, leading to lower TTFT.

---

# Experiment 2 — FlashAttention

## Goal

Measure improvement in **prefill throughput** when using FlashAttention.

## Workload

Use prompts with long context:


1000–4000 tokens


## Procedure

1. Run inference with the **standard attention implementation**.
2. Measure prefill latency.
3. Enable **FlashAttention** in the runtime.
4. Run the same prompts again.
5. Compare results.

## Metrics

- Prompt tokens/sec
- Prefill latency
- GPU memory bandwidth utilization

## Expected Result

FlashAttention should significantly improve prompt processing speed, especially for long contexts.

---

# Experiment 3 — Continuous Batching

## Goal

Measure improvements in **throughput and GPU utilization** under concurrent load.

## Workload

Simulate increasing concurrency levels:

1 → 8 → 16 → 32 concurrent sessions

## Procedure

1. Disable dynamic batching.
2. Run requests at increasing concurrency levels.
3. Record tokens/sec and GPU utilization.
4. Enable continuous batching.
5. Repeat the same workload.
6. Compare results.

## Metrics

- tokens/sec
- active sequences per GPU
- GPU utilization
- inter-token latency

## Expected Result

Continuous batching should increase GPU utilization and improve tokens/sec under load.

---

# Future Experiments

We will add these additional experiments later:

- **Experiment 4 — Quantization**
- **Experiment 5 — Speculative Decoding**

These complete the core set of optimization techniques commonly used in modern LLM 
