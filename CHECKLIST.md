# GenAI Model Deployment Checklist (v0.1)

*A community-driven checklist for preparing GenAI models including LLMs, diffusion models, embedding pipelines, and multimodal systems for production deployment.*

## 📘 Table of Contents
1. [🔥 Model Identity](#-1-model-identity)
2. [⚙️ Compute & GPU Planning](#%EF%B8%8F-2-compute--gpu-planning)
3. [📊 Performance Objectives](#-3-performance-objectives)
4. [🔀 Routing & Release Strategy](#-4-routing--release-strategy)
5. [📈 Autoscaling Requirements](#-5-autoscaling-requirements)
6. [🕵️ Observability](#%EF%B8%8F-6-observability)
7. [🛡️ Reliability](#%EF%B8%8F-7-reliability)
8. [🔒 Security & Compliance](#-8-security--compliance)
9. [📁 Operational Metadata](#-9-operational-metadata)

---

## 🔥 **1. Model Identity**
- [ ] Model name, version, and revision  
- [ ] Fine-tune lineage or variant  
- [ ] Supported modalities (text, image, audio, multimodal)  
- [ ] Maximum input size or token/window constraints  
- [ ] Compatible GPU types and precision modes tested  

## ⚙️ **2. Compute & GPU Planning**
- [ ] Peak memory usage at expected input sizes  
- [ ] Optimal batch size ranges (tokens, images, samples, embeddings, etc.)  
- [ ] Throughput-per-dollar or throughput-per-GPU analysis  
- [ ] Node affinity or required instance types  
- [ ] Multi-GPU, tensor parallel, or pipeline parallel requirements  
- [ ] Required quantization formats (FP16, BF16, INT8, etc.)  

## 📊 **3. Performance Objectives**
- [ ] Target latency (p50 and p95) for each operation (prefill, decode, denoise step, embedding call)  
- [ ] Expected throughput (tokens/sec, images/sec, samples/sec, queries/sec)  
- [ ] Defined load profile assumptions (peak vs steady-state)  
- [ ] Cost targets per inference or per output unit  

## 🔀 **4. Routing & Release Strategy**
- [ ] Canary or weighted rollout plan  
- [ ] Shadow evaluation pipeline  
- [ ] Rollback criteria  
- [ ] Drift detection or evaluation suite alignment  
- [ ] Compatibility testing across model versions  

## 📈 **5. Autoscaling Requirements**
- [ ] Cold start time measured and documented  
- [ ] Warmup requirements (e.g., KV cache priming, diffusion graph warmup)  
- [ ] Batch window considerations  
- [ ] Predictive vs reactive scaling strategy defined  
- [ ] Peak vs steady-state traffic expectations documented  

## 🕵️ **6. Observability**
- [ ] Latency decomposition (prefill vs decode for LLMs; denoising steps for diffusion; embedding latency for retrieval)  
- [ ] GPU utilization and memory fragmentation  
- [ ] Cache-related metrics (KV cache, intermediate tensors, attention state)  
- [ ] Error classes: OOM, shape mismatch, tokenizer/model config mismatch, load failures  
- [ ] Throughput monitoring (tokens/sec, samples/sec, queries/sec)  

## 🛡️ **7. Reliability**
- [ ] Warmup behavior documented  
- [ ] Retries and backpressure strategy defined  
- [ ] Timeout logic aligned with model behavior  
- [ ] Handling of input shape or prompt variability  
- [ ] Resilience testing for peak loads and traffic bursts  

## 🔒 **8. Security & Compliance**
- [ ] Input sanitization policies  
- [ ] Logging mode (PII, redaction, and retention)  
- [ ] Access control and keys management  
- [ ] Model behavior or safety constraints documented  
- [ ] Data governance requirements  

## 📁 **9. Operational Metadata**
- [ ] Owner/team responsible  
- [ ] Defined SLOs for latency, cost, and throughput  
- [ ] Dependencies or required external services  
- [ ] Resource contract fields (for future ModelSpec use)  
- [ ] Documentation of runtime constraints and assumptions  

## 🔗 Related Checklists & Guides

-  **GenAI Model Deployment Checklist**  
  [`/CHECKLIST.md`](../CHECKLIST.md)

-  **AI Infrastructure Best Practices**  
  [`ai-infrastructure-best-practices-and-playbooks/`](../ai-infrastructure-best-practices-and-playbooks/)

-  **AI Infrastructure Audit & Readiness (42-Point)**  
  [`ai-infrastructure-audit-and-readiness-checklist/`](../ai-infrastructure-audit-and-readiness-checklist/)

-  **AI Governance & Compliance Checklist**  
  [`ai-governance-and-compliance-checklist/`](../ai-governance-and-compliance-checklist/)

-  **Model Deployment Quality Checklist**  
  [`ai-model-deployment-quality-checklist/`](../ai-model-deployment-quality-checklist/)

-  **LLM Inference Production Readiness (Kubernetes + vLLM)**  
  [`llm-inference-production-readiness-checklist/`](../llm-inference-production-readiness-checklist/)

-  **vLLM Runtime Metrics & Observability Guide**  
  [`vllm-runtime-metrics-and-observability-guide/`](../vllm-runtime-metrics-and-observability-guide/)