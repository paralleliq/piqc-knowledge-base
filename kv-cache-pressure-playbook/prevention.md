# Preventing KV Cache Pressure (vLLM)

This checklist helps ensure **KV cache pressure does not recur** after an incident.
The focus is on **explicit limits, visibility, and reviewability**.

Use this during design reviews, pre-production validation, and after incidents.

---

## 1) Enforce request-level limits

KV cache grows with tokens-in-flight. Never trust clients to self-limit.

- [ ] **Max input tokens** enforced at the API or gateway layer  
- [ ] **Max output tokens** enforced for every request  
- [ ] Requests exceeding limits are **rejected**, not truncated silently  
- [ ] Streaming responses have bounded duration / tokens  

**Interpretation:** 

Long or unbounded prompts are the most common trigger of KV cache explosions.

---

## 2) Control runtime concurrency explicitly

Concurrency directly multiplies KV cache usage.

- [ ] `max_num_seqs` is explicitly set  
- [ ] Concurrency is derived from **GPU memory**, not guesswork  
- [ ] Separate deployments for long-context vs short-context traffic  

**Interpretation:** 

Scaling replicas does not fix per-replica KV pressure.

---

## 3) Bound batching behavior

Batching improves throughput but increases tokens-in-flight.

- [ ] `max-num-batched-tokens` is explicitly set  
- [ ] Batching limits are tested under peak prompt sizes  
- [ ] Batch effectiveness is monitored (p95, p99)  

**Interpretation:**  

Unbounded batching accelerates KV cache growth and fragmentation.

---

## 4) Reserve GPU memory headroom

Avoid running GPUs “full”.

- [ ] `gpu-memory-utilization` ≤ **0.7**  
- [ ] Lower (≤ 0.6) for long-context or bursty workloads  
- [ ] Headroom validated under peak traffic  

**Interpretation:**  

Allocator overhead and fragmentation cause crashes before memory is truly “full”.

---

## 5) Observe the right signals

GPU utilization alone is misleading.

- [ ] GPU memory utilization (%)  
- [ ] Effective batch size (p95)  
- [ ] p95 / p99 request latency  
- [ ] Active sequences / in-flight requests  

**Interpretation:**  

KV cache pressure presents as **memory high + compute low**.

---

## 6) Monitor prompt and traffic shape

Understand what your users are sending.

- [ ] Prompt length distribution tracked  
- [ ] `max_tokens` distribution tracked  
- [ ] Bursty traffic patterns identified  
- [ ] RAG chunk sizes bounded  

**Interpretation:**  

Traffic *shape* matters more than raw QPS.

---

## 7) Make limits explicit and reviewable

Prevent “it worked in staging” failures.

- [ ] Token limits documented  
- [ ] Concurrency limits documented  
- [ ] GPU memory targets documented  
- [ ] Reviewed before production rollout  

**Interpretation:**  

Undeclared intent leads to rediscovering limits during incidents.

---

## 8) Validate under realistic load

- [ ] Load tests include **long prompts**  
- [ ] Load tests include **burst scenarios**  
- [ ] KV cache behavior observed during tests  

**Interpretation:**  

Most KV cache failures only appear under realistic traffic.

---

## 9) Use chunked prefill for long-context / RAG workloads (if supported)

Chunked prefill processes long prompts in smaller segments to reduce peak KV cache allocation and improve batching stability under memory pressure.

- [ ] If you serve long-context or RAG traffic, evaluate enabling **chunked prefill**
- [ ] Validate impact on latency and throughput under realistic long-prompt load
- [ ] Monitor GPU memory headroom and effective batch size before/after enabling

---

## Summary

KV cache pressure is not a tuning accident — it is a **control problem**.

Prevent it by:
- bounding what the model is allowed to do
- enforcing those bounds consistently
- observing the signals that matter

If these limits are not explicit, the system will eventually find them for you.

