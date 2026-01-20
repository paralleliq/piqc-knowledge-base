# Training–Serving Skew Playbook (Configuration Mismatch)

Training–serving skew is when the model that runs in production is not executed under the same assumptions
as the model that was trained, validated, or benchmarked—often without any explicit crash.

This playbook helps you:
- detect skew quickly
- identify where mismatch is happening (model, runtime, hardware, serving, orchestration)
- apply safe mitigations
- prevent recurrence with “contract-style” configuration (for example, [ModelSpec](https://github.com/paralleliq/modelspec))

> **Applies across models, runtimes, and infrastructure**
>
> Training–serving skew arises when assumptions made during training diverge from production runtime behavior, serving configuration, or infrastructure constraints. Training–serving skew is not framework- or vendor-specific.  The examples use CUDA because that’s what’s most familiar today.


## When to use this
Use this playbook if you observe:
- unexplained latency/throughput regressions after a rollout
- quality regressions with no weight changes
- GPU cost spikes despite “same” model
- differences between staging and prod behavior

## Quick links
- [Diagnostics](diagnostics.md)
- [Emergency Mitigation](emergency-mitigation.md)
- [Prevention](prevention.md)

## What “skew” typically means in practice
Common mismatch categories:
- **Model artifacts**: wrong weights, tokenizer, revision, or config
- **Runtime**: dtype, quantization, batching, max context, concurrency, scheduling settings
- **Hardware**: different GPU class, VRAM, interconnect, driver/CUDA stack
- **Serving**: timeouts, streaming mode, request size limits, retries
- **Orchestration**: autoscaling metrics, pod resources, node affinity, warm pools

## Evidence mindset (important)
To avoid guesswork, aim to collect:
- “what we intended” (declared config, chart values, ModelSpec)
- “what is actually running” (runtime flags/env, live pod specs, metrics)
- “what changed” (diffs between last-good and current)

If you can’t show a difference, you’re not done debugging.

## 🔗 Related Checklists & Guides

-  **GenAI Model Deployment Checklist**  
  [`/CHECKLIST.md`](../CHECKLIST.md)

-  **AI Infrastructure Best Practices**  
  [`ai-infrastructure-best-practices-and-playbooks/`](../ai-infrastructure-best-practices-and-playbooks/)

-  **AI Infrastructure Audit & Readiness (42-Point)**  
  [`ai-infrastructure-audit-and-readiness-checklist/`](../ai-infrastructure-audit-and-readiness-checklist/)

-  **AI Governance & Compliance Checklist**  
  [`ai-governance-and-compliance-checklist/`](../ai-governance-and-compliance-checklist/)

-  **AI Governance & Compliance Checklist**  
  [`ai-governance-and-compliance-checklist/`](../ai-governance-and-compliance-checklist/)

-  **Model Deployment Quality Checklist**  
  [`ai-model-deployment-quality-checklist/`](../ai-model-deployment-quality-checklist/)

-  **LLM Inference Production Readiness (Kubernetes + vLLM)**  
  [`llm-inference-production-readiness-checklist/`](../llm-inference-production-readiness-checklist/)

-  **vLLM Runtime Metrics & Observability Guide**  
  [`vllm-runtime-metrics-and-observability-guide/`](../vllm-runtime-metrics-and-observability-guide/)

-  **GPU Utilization Interpretation Guide**  
  [`gpu-utilization-interpretation-guide/`](../gpu-utilization-interpretation-guide/)

-  **KV Cache Pressure Playbook**  
  [`kv-cache-pressure-playbook/`](../kv-cache-pressure-playbook/)


