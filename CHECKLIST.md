# GenAI Model Deployment Checklist (v0.1)

*A community-driven, model-agnostic checklist for preparing GenAI systems including LLMs, diffusion models, embedding services, and multimodal pipelines for production deployment.*

## 📘 Table of Contents
1. [🔥 Model Identity](#-1-model-identity)  
2. [⚙️ Compute & GPU Planning](#️-2-compute--gpu-planning)  
3. [📊 Performance Objectives](#-3-performance-objectives)  
4. [🔀 Routing & Release Strategy](#-4-routing--release-strategy)  
5. [📈 Autoscaling Requirements](#-5-autoscaling-requirements)  
6. [🕵️ Observability](#️-6-observability)  
7. [🛡️ Reliability](#️-7-reliability)  
8. [🔒 Security & Compliance](#-8-security--compliance)  
9. [📁 Operational Metadata](#-9-operational-metadata)  

## 🔥 **1. Model Identity**
- [ ] Model name, version, revision  
- [ ] Fine-tune lineage or variant  
- [ ] Supported modalities (text, image, audio, multimodal)  
- [ ] Maximum input size / token limits  
- [ ] Supported GPU types + precision modes  

## ⚙️ **2. Compute & GPU Planning**
- [ ] Peak memory usage measured  
- [ ] Optimal batch size ranges  
- [ ] Throughput-per-GPU or cost-per-token analysis  
- [ ] Required node affinity or instance types  
- [ ] Multi-GPU (TP/PP) requirements validated  
- [ ] Supported quantization formats (FP16/BF16/INT8/etc.)  

## 📊 **3. Performance Objectives**
- [ ] Latency targets (p50/p95) for prefill/decode/denoise  
- [ ] Expected throughput (tokens/s, samples/s, QPS)  
- [ ] Peak vs steady-state load assumptions documented  
- [ ] Cost-per-inference targets defined  

## 🔀 **4. Routing & Release Strategy**
- [ ] Canary / weighted rollout strategy  
- [ ] Shadow evaluation pipeline  
- [ ] Rollback conditions  
- [ ] Drift detection or eval-suite alignment  
- [ ] Backward compatibility between model versions  

## 📈 **5. Autoscaling Requirements**
- [ ] Cold start time measured  
- [ ] Warmup (KV Cache / graph warmup) documented  
- [ ] Batch window and queueing strategy  
- [ ] Predictive vs reactive scaling approach  
- [ ] Peak load vs steady load notes  

## 🕵️ **6. Observability**
- [ ] Latency decomposition (prefill vs decode vs steps)  
- [ ] GPU utilization + fragmentation visibility  
- [ ] Cache metrics (KV, attention, intermediates)  
- [ ] Error classes tracked (OOM, shape mismatch, tokenizer mismatch)  
- [ ] Throughput metrics (QPS / TPS / samples/s)  

## 🛡️ **7. Reliability**
- [ ] Warmup behavior validated  
- [ ] Retry + backpressure strategies  
- [ ] Timeout logic aligned with model behavior  
- [ ] Input shape / prompt variability tested  
- [ ] Stress & load testing performed  

## 🔒 **8. Security & Compliance**
- [ ] Input sanitization rules  
- [ ] Logging mode (PII, retention, redaction)  
- [ ] Access control + API key management  
- [ ] Safety behavior documented  
- [ ] Data governance policies applied  

## 📁 **9. Operational Metadata**
- [ ] Team/owner defined  
- [ ] SLOs for latency, cost, throughput  
- [ ] External service dependencies listed  
- [ ] Resource contract fields for ModelSpec  
- [ ] Runtime constraints documented  

## 🔗 Related Guides

- [AI Infrastructure Best Practices](../ai-infrastructure-best-practices-and-playbooks/)  
- [AI Infrastructure Audit Checklist](../ai-infrastructure-audit-and-readiness-checklist/)  
- [AI Governance & Compliance Checklist](../ai-governance-and-compliance-checklist/)  
- [Model Deployment Quality Checklist](../ai-model-deployment-quality-checklist/)  
- [LLM Inference Production Readiness](../llm-inference-production-readiness-checklist/)  
- [vLLM Runtime Metrics Guide](../vllm-runtime-metrics-and-observability-guide/)

---

<div align="center">
  <sub>Part of the <a href="https://github.com/paralleliq/piqc-knowledge-base">PIQC Knowledge Base</a></sub>
  <br/>
  <sub>Maintained by <a href="https://paralleliq.ai">ParalleliQ</a></sub>
</div>