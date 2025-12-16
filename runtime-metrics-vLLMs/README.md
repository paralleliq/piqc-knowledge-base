
# vLLM Runtime Metrics & Signals for PIQC  
### Model Serving Telemetry, Runtime Insights & Optimization Signals for Advisor

A structured, vendor-neutral catalog of **static and dynamic runtime signals** required to analyze, diagnose, and optimize **LLM inference workloads running on vLLM**.

These signals power PIQC’s model deployment quality insights, enabling teams to understand:

- **True GPU efficiency vs underutilization**
- **Batching behavior & collapse under load**
- **Latency curves & tail performance**
- **Autoscaling correctness**
- **Memory & KV cache pressure**
- **Throughput bottlenecks (RPS/TPS)**
- **Parallelism effectiveness (TP/PP)**
- **Runtime misconfiguration & drift**

<p align="left">
  <img src="https://img.shields.io/badge/Category-LLM%20Inference-blue.svg?style=flat-square">
  <img src="https://img.shields.io/badge/Runtime-vLLM%20%7C%20GPU%20Inference-brightgreen.svg?style=flat-square">
  <img src="https://img.shields.io/badge/Focus-Metrics%20%26%20Signals-lightgrey.svg?style=flat-square">
  <img src="https://img.shields.io/badge/Spec-Publiс%20Reference-orange.svg?style=flat-square">
</p>
---

## 📘 What This Document Provides

vLLM exposes a rich set of **telemetry and configuration signals** that PIQC consumes for:

- Deployment diagnostics  
- Autoscaling validation  
- Model performance baselining  
- Cost & GPU efficiency scoring  
- Detecting misconfigurations  
- Comparing replicas across clusters  

Each metric is tagged as:

- **S = Static** → does not change at runtime  
- **D = Dynamic** → varies with load / traffic  

This lets PIQC distinguish between **what the deployment *is*** and **how it's behaving under real load**.


# 🟦 A. Runtime Identity & Configuration (Static)

These anchor inference logic and version-aware rules.

### 1. Engine Type (vLLM) [S]  
Used to load correct runtime semantics.

### 2. Engine Version (e.g., 0.5.0) [S]  
Enables version-specific diagnostics.

### 3. Model ID(s) (HF Name) [S]  
Pulled from `/v1/models` or startup args.

### 4. Model Parameter Count (e.g., 7B, 70B) [S]  
Critical for GPU sizing & performance rules.

### 5. Precision / dtype (fp16, bf16, int8) [S]  
Used to detect wasteful precision.

### 6. Quantization Type (awq, gptq, none) [S]  
Affects memory footprint & latency.


# 🟪 B. Parallelism & Resource Shape (Static)

Defines how the model maps to hardware.

### 7. GPU Count per Replica [S]  
Right-sizing & consolidation analysis.

### 8. Tensor Parallel Size [S]  
Detects over/under-sharding.

### 9. Pipeline Parallel Size [S]  
Used for very large models.

### 10. Max Context Length (`max_model_len`) [S]  
Drives KV cache allocation.


# 🟨 C. Feature Enablement (Static)

Core capabilities that shape performance.

### 11. Continuous Batching Enabled [S]  
Essential for throughput efficiency.

### 12. Paged Attention Enabled [S]  
Critical for long-context models.

### 13. Speculative Decoding Enabled [S]  
Used for latency optimizations.

### 14. KV Cache Policy [S]  
Impacts memory stability.


# 🟩 D. Load & Throughput (Dynamic)

Shows actual runtime demand.

### 15. Requests per Second (RPS) [D]  
Autoscaling sanity checks.

### 16. Tokens per Second (TPS) [D]  
Better scaling signal than RPS.

### 17. Tokens per Request (Distribution) [D]  
Workload characterization.


# 🟧 E. Batching Behavior (Dynamic)

Where most efficiency loss occurs.

### 18. Effective Batch Size — p50 [D]  
Detects batching inefficiencies.

### 19. Effective Batch Size — p95 [D]  
Headroom vs collapse under load.

### 20. Max Observed Batch Size [D]  
Checks if configured batch is ever reached.

# 🟥 F. Latency & Tail Performance (Dynamic)

SLA-critical indicators.

### 21. Latency p50 [D]  
Baseline performance.

### 22. Latency p95 [D]  
Used for autoscaling & batching decisions.

### 23. Latency p99 [D]  
Reveals saturation, queueing, KV thrash.


# 🟫 G. Stability & Error Signals (Dynamic)

Detects overload and misconfiguration.

### 24. Error Rate / Failed Requests [D]  
Shows overload or config issues.

### 25. Queue Depth / Backlog [D]  
Key signal for diagnosing when scaling **won’t** help.

---

## 📌 Summary

These signals form the **public, non-proprietary specification** of what PIQC Advisor consumes to:

- Evaluate LLM inference efficiency  
- Diagnose performance bottlenecks  
- Detect misconfiguration or drift  
- Score deployment quality  
- Provide actionable optimization insights  

> Diagnostic *logic* is PIQC-proprietary —  
> This file defines only the **open signal contract**.
