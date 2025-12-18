
# LLM Inference Readiness Checklist (Kubernetes + vLLM)
### Day-0 → Day-2 Readiness Framework for Production-Grade LLM Deployment

A structured, cross-functional checklist for deploying **Large Language Models (LLMs)** using **vLLM** on **Kubernetes**.  
This guide aligns responsibilities across ML Engineering, MLOps, SRE, Platform/Infra, and Security teams to ensure consistent and reliable production rollout.

<p align="left">
  <img src="https://img.shields.io/badge/Category-LLM%20Infrastructure-blue.svg?style=flat-square">
  <img src="https://img.shields.io/badge/Runtime-vLLM-orange.svg?style=flat-square">
  <img src="https://img.shields.io/badge/Platform-Kubernetes-brightgreen.svg?style=flat-square">
  <img src="https://img.shields.io/badge/Stage-Day0→Day2-lightgrey.svg?style=flat-square">
</p>


## 📘 Overview

This checklist helps teams validate whether an LLM is ready for production deployment on Kubernetes. It covers:

- Model verification (artifacts, precision, constraints)
- Runtime configuration (vLLM tuning, batching, dtype)
- Kubernetes infrastructure (GPU nodes, manifests, storage)
- Observability (metrics, logs, tracing)
- Autoscaling (token-based, latency-based, utilization-based)
- Release & operations (SRE readiness, rollback, cost awareness)

---

# Phase 0: Model & Intent Readiness (Before Any Cluster Work)

### 🎯 Goal: Validate artifacts + deployment intent before touching Kubernetes.

## Model Artifact Readiness  
**Owner: ML Engineer**

- [ ] Model weights exported in a deployable HF-style format  
- [ ] Tokenizer files present and **version-locked**  
- [ ] Model license reviewed and approved  
- [ ] Parameter count documented (7B / 13B / 70B / etc.)  


## Inference Constraints Defined  
**Owners: ML Engineer + Product**

- [ ] Max context length defined  
- [ ] Expected prompt length (p50 / p95)  
- [ ] Expected response length (p50 / p95)  
- [ ] Latency SLO (p95 / p99)  
- [ ] Throughput expectations (QPS or tokens/sec)  


## Precision & Optimization Intent  
**Owner: ML Engineer**

- [ ] Precision selected (fp32 / fp16 / bf16)  
- [ ] Quantization allowed? (AWQ / GPTQ / none)  
- [ ] Accuracy tradeoffs documented  

---

# Phase 1: Runtime & Packaging (Day-0)

### 🎯 Goal: Build a runtime that efficiently serves the model.

## Runtime Selection  
**Owner: ML Platform / MLOps**

- [ ] Runtime chosen (vLLM)  
- [ ] Runtime version pinned  
- [ ] Serving interface chosen (OpenAI-compatible or custom)  

## vLLM Runtime Configuration  
**Owner: MLOps**

- [ ] Model path or registry reference defined  
- [ ] `--dtype` explicitly set  
- [ ] `--max-model-len` aligned with real usage  
- [ ] Batching settings (max-num-seqs, max-batched-tokens)  
- [ ] Tensor parallel size chosen intentionally  
- [ ] Continuous batching enabled  


## Packaging Strategy  
**Owners: Platform / MLOps**

- [ ] Model loading strategy chosen (runtime pull / baked image / storage mount)  
- [ ] Cold-start behavior documented  
- [ ] Secrets handled securely  


## Container Image  
**Owner: MLOps**

- [ ] CUDA-compatible base image  
- [ ] vLLM installed & validated  
- [ ] Entrypoint tested locally (single GPU)  
- [ ] Image scanned + pushed to registry  

---

# Phase 2: Kubernetes & Infrastructure Readiness (Day-1)

### 🎯 Goal: Ensure GPU nodes + infra can run LLM inference reliably.


## GPU Infrastructure  
**Owners: Infra / Platform**

- [ ] NVIDIA drivers installed  
- [ ] NVIDIA device plugin active  
- [ ] GPU nodes correctly labeled/tainted  
- [ ] GPU type + memory documented  


## Storage  
**Owner: Platform**

- [ ] Model storage bandwidth benchmarked  
- [ ] PVC / NFS / Object Store access tested  
- [ ] Pod-level access permissions validated  


## Kubernetes Manifests  
**Owner: MLOps**

- [ ] Deployment / StatefulSet configured  
- [ ] GPU resource requests/limits correct  
- [ ] `/dev/shm` configured  
- [ ] Readiness probe waits for full model load  
- [ ] Restart behavior validated  


## Networking & Access  
**Owners: Platform + Security**

- [ ] Service (ClusterIP / LoadBalancer) defined  
- [ ] Ingress / API Gateway set  
- [ ] AuthN/AuthZ implemented  
- [ ] Network policies applied  

---

# Phase 3: Observability & Autoscaling (Day-1 → Day-2)

### 🎯 Goal: Understand real runtime behavior before scaling or optimizing.


## Metrics & Logs  
**Owner: SRE / Platform**

- [ ] `/metrics` exposed  
- [ ] Metrics scraped (Prometheus / OTel)  
- [ ] Latency histograms visible  
- [ ] Error counters / timeout metrics  
- [ ] GPU metrics (DCGM)  


## Autoscaling Configuration  
**Owner: SRE**

- [ ] HPA uses custom **ML metrics**  
- [ ] Scaling signal chosen (tokens/sec, RPS, latency)  
- [ ] Min/max replicas justified  
- [ ] Cooldowns tuned  


## Autoscaling Sanity Check  
**Owners: SRE + MLOps**

- [ ] Scaling improves throughput  
- [ ] Scaling reduces latency  
- [ ] GPUs are not underutilized  
- [ ] Scaling is not hiding misconfigurations  

---

# Phase 4: Production Readiness & Operations (Day-2)

### 🎯 Goal: Ensure the system is safe to run, debug, scale, and release.


## Release Strategy  
**Owners: SRE + MLOps**

- [ ] Rolling / Blue-Green strategy defined  
- [ ] Canary prompts prepared  
- [ ] Rollback path tested end-to-end  


## Failure & Cost Awareness  
**Owners: SRE + Platform + Finance**

- [ ] OOM behavior understood  
- [ ] Node failure tested  
- [ ] Cost per replica estimated  
- [ ] Idle GPU detection enabled  


## Drift & Optimization  
**Owners: MLOps + SRE**

- [ ] Runtime config matches initial intent  
- [ ] Precision & parallelism reviewed periodically  
- [ ] Batching effective under real traffic  
- [ ] Autoscaling decisions reviewed  

