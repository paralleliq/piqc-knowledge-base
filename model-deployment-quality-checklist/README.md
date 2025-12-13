# PIQC Model Deployment Quality Checklist  
(Proposed Advisor Diagnostic Categories)

A high-level checklist outlining diagnostic categories used to evaluate the quality of deployed AI/LLM model services.

These categories inform the **future direction** of PIQC Advisor.

---

## 1. GPU Efficiency
- Under-utilized GPUs
- Inefficient batch sizes
- Suboptimal precision
- Poor sharding or parallelism

## 2. Memory Configuration
- Unnecessary GPU count
- OOM-risk configurations
- Wasteful memory headroom

## 3. Autoscaling Behavior
- Incorrect metrics
- Replica imbalance
- Slow scaling responses

## 4. Engine & Runtime Configuration
- Outdated engine versions
- Disabled optimizations
- Misaligned scheduling policies

## 5. Routing & Endpoint Health
- Unhealthy rollouts
- Load imbalance
- Lack of canarying

## 6. Reliability & Deployment Hygiene
- Missing probes
- Resource mismatches
- Configuration drift

## 7. Cross-Model & Pipeline-Level Issues
- Inter-model bottlenecks
- Dependency misalignment
- Duplicate deployments
- Version inconsistency

---

These checks are **conceptual only**.  
Underlying detection algorithms remain proprietary to PIQC Advisor.

Feedback and additional categories are welcome.
