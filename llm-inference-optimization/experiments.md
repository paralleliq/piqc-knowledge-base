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

# Experiment 4 — Quantization

## Goal

Measure the impact of **model quantization** on inference latency, throughput, and memory usage.

Quantization reduces model precision (for example from FP16 to INT8 or INT4) to improve performance and reduce GPU memory consumption.

## Workload

Use prompts with moderate length:


500–1500 tokens


Use the same prompt set for both baseline and quantized runs.

## Procedure

1. Run inference using the baseline model (e.g., FP16).
2. Record performance metrics.
3. Load a quantized version of the same model (e.g., INT8 or INT4).
4. Run the same prompts.
5. Compare performance and resource usage.

## Metrics

- TTFT
- tokens/sec
- GPU memory usage
- GPU utilization

## Expected Result

Quantized models typically:

- reduce GPU memory usage
- increase throughput
- slightly impact model accuracy depending on quantization level.

---

# Experiment 5 — Speculative Decoding

## Goal

Measure improvements in **token generation throughput** using speculative decoding.

Speculative decoding uses a **smaller draft model** to predict multiple tokens ahead while the larger model verifies them.

## Workload

Use prompts of moderate size:

500–1500 tokens

Generate responses of ~100 tokens to observe decode behavior.

## Procedure

1. Run inference using the baseline model without speculative decoding.
2. Record decode throughput.
3. Enable speculative decoding with a smaller draft model.
4. Run the same prompts.
5. Compare token generation performance.

## Metrics

- tokens/sec
- inter-token latency
- acceptance rate of draft tokens
- GPU utilization

## Expected Result

Speculative decoding can significantly improve **decode throughput**, especially for large models, by allowing multiple tokens to be generated per verification step.

These complete the core set of optimization techniques commonly used in modern LLM 
