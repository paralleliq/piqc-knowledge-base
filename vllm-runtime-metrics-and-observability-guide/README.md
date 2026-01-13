
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
-	Source: pod/image/annotation
-	Used to select runtime semantics & ruleset


### 2. Engine Version (e.g., 0.5.0) [S]  
-	Source: image tag or /metrics
-	Enables version-specific warnings


### 3. Model ID(s) (HF Name) [S]  
-	Source: /v1/models, startup args
-	Needed for model metadata enrichment


### 4. Model Parameter Count (e.g., 7B, 70B) [S]  
-	Source: HF metadata / PIQC model catalog
-	Critical for almost all optimization rules


### 5. Precision / dtype (fp16, bf16, int8) [S]  
-	Source: vLLM config / metrics
-	Used for wasteful-precision detection


### 6. Quantization Type (awq, gptq, none) [S]  
-	Source: startup args / metrics
-	Cost–latency tradeoff reasoning



# 🟪 B. Parallelism & Resource Shape (Static)

Defines how the model maps to hardware.

### 7. GPU Count per Replica [S]  
-	Source: pod resource limits
-	Used for right-sizing & consolidation analysis


### 8. Tensor Parallel Size [S]  
-	Source: vLLM args / env
-	Detects over-sharding or under-sharding


### 9. Pipeline Parallel Size [S]  
-	Source: vLLM config
-	Used mostly for very large models


### 10. Max Context Length (`max_model_len`) [S]  
-	Source: startup args / config
-	Drives KV cache sizing logic



# 🟨 C. Feature Enablement (Static)

Core capabilities that shape performance.

### 11. Continuous Batching Enabled [S]  
-	Source: vLLM config
-	Essential for throughput efficiency

### 12. Paged Attention Enabled [S]  
-	Source: vLLM config/version inference
-	Required for memory-efficient long contexts


### 13. Speculative Decoding Enabled [S]  
-	Source: config / presence of draft model
-	Latency optimization detection


### 14. KV Cache Policy [S]  
-	Source: vLLM defaults + flags
-	Enables KV-pressure reasoning



# 🟩 D. Load & Throughput (Dynamic)

These tell you how hard the model is actually working.

### 15. Requests per Second (RPS) [D]  
-	Derived from requests_total over time
- Autoscaling sanity checks


### 16. Tokens per Second (TPS) [D]  
-	Derived from tokens_total
-	Much better scaling signal than RPS


### 17. Tokens per Request (Distribution) [D]  
-	Derived: TPS / RPS or histogram if available
-	Context sizing & traffic characterization



# 🟧 E. Batching Behavior (Dynamic)

- Where most efficiency loss occurs.

### 18. Effective Batch Size — p50 [D]  
-	From batch size histogram
-	Detects ineffective batching


### 19. Effective Batch Size — p95 [D]  
- Headroom vs collapse under load.

### 20. Max Observed Batch Size [D]  
- Checks if configured batch is ever reached.

# 🟥 F. Latency & Tail Performance (Dynamic)

- SLA-critical indicators.

### 21. Latency p50 [D]  
- Baseline performance.

### 22. Latency p95 [D]  
- Used for autoscaling & batching decisions.

### 23. Latency p99 [D]  
- Reveals saturation, queueing, KV thrash.


# 🟫 G. Stability & Error Signals (Dynamic)

Detects overload and misconfiguration.

### 24. Error Rate / Failed Requests [D]  
-	From error counters
-	Detects overload or misconfig


### 25. Queue Depth / Backlog [D]  
-	If explicit metric exists, use it
-	Otherwise infer from latency + batch collapse
-	Key for “scaling won’t help” diagnoses


---

## 📌 Summary

These signals form the public, non-proprietary specification of what PIQC Advisor consumes to:

- Evaluate LLM inference efficiency  
- Diagnose performance bottlenecks  
- Detect misconfiguration or drift  
- Score deployment quality  
- Provide actionable optimization insights  

> Diagnostic *logic* is PIQC-proprietary  
> This file defines only the **open signal contract**.

## 🔗 Related Checklists & Guides

-  **GenAI Model Deployment Checklist**  
  [`/CHECKLIST.md`](../CHECKLIST.md)

-  **AI Infrastructure Best Practices**  
  [`ai-infrastructure-best-practices-and-playbooks/`](../ai-infrastructure-best-practices-and-playbooks/)

-  **AI Infrastructure Audit & Readiness (42-Point)**  
  [`ai-infrastructure-audit-and-readiness-checklist/`](../ai-infrastructure-audit-and-readiness-checklist/)

-  **AI Governance & Compliance Checklist**  
  [`ai-governance-and-compliance-checklist/`](../ai-governance-and-compliance-checklist/)

-  **AI Cluster Bringup Checklist**  
  [`ai-cluster-bringup-checklist/`](../ai-cluster-bringup-checklist/)

-  **Model Deployment Quality Checklist**  
  [`ai-model-deployment-quality-checklist/`](../ai-model-deployment-quality-checklist/)

-  **LLM Inference Production Readiness (Kubernetes + vLLM)**  
  [`llm-inference-production-readiness-checklist/`](../llm-inference-production-readiness-checklist/)

-  **vLLM Runtime Metrics & Observability Guide**  
  [`vllm-runtime-metrics-and-observability-guide/`](../vllm-runtime-metrics-and-observability-guide/)
