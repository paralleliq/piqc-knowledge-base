# Glossary Taxonomy

This document defines the organizational structure of the LLM Model Deployment Glossary.
It ensures consistent categorization, tagging, and navigation across all glossary entries.

---

## Primary Categories

Every term must belong to exactly **one primary category**.

### Execution
Concepts related to how models actually run on GPUs or accelerators.
Examples:
- KV Cache  
- Paged Attention  
- Prefill  
- Decode  
- Speculative Decoding  

### Serving
Concepts related to request handling, APIs, concurrency, and user-facing behavior.
Examples:
- Batching  
- Scheduler  
- Queueing Delay  
- Streaming  
- Session State  

### Control Plane / Orchestration
Concepts related to scaling, provisioning, placement, and lifecycle management.
Examples:
- Autoscaling  
- Warm Pool  
- Serverless Architecture  
- Scale-to-Zero  
- Provisioning Latency  

### GPU & Memory
Concepts related to device memory, allocation, fragmentation, and capacity limits.
Examples:
- OOM  
- Memory Fragmentation  
- GPU HBM  
- MIG  
- Block Allocator  

### Distributed Parallelism
Concepts related to multi-GPU and multi-node execution.
Examples:
- Tensor Parallelism  
- Pipeline Parallelism  
- Data Parallelism  
- All-Reduce  
- Collective Communication  

### Scheduling & Admission
Concepts related to ordering, fairness, and execution control.
Examples:
- Scheduler  
- Admission Control  
- Active Sequences  
- Head-of-Line Blocking  

### Performance & Metrics
Concepts related to latency, throughput, and observability.
Examples:
- TTFT  
- TPOT  
- Tokens Per Second  
- Tail Latency  
- Effective Batch Size  

### Reliability & Failure Modes
Concepts related to instability, degradation, and recovery.
Examples:
- Cold Start  
- OOM  
- Thrashing  
- Cascading Restart  
- Retry Storm  

---

## Tags

Optional short labels that further classify a term.  
Each term may include **up to 3 tags**.

Allowed tags:

- `execution`  
- `serving`  
- `control-plane`  
- `gpu-memory`  
- `distributed`  
- `scheduling`  
- `metrics`  
- `latency`  
- `throughput`  
- `reliability`  
- `kubernetes`  
- `autoscaling`  

---

## Core vs Advanced Terms

Optionally mark foundational terms as:

- **Core** — fundamental concepts every practitioner should understand  
  Examples: Batching, KV Cache, Autoscaling, Scheduler  

- **Advanced** — specialized or optimization techniques  
  Examples: Paged Attention, Speculative Decoding, Prefix Caching  

---

## Naming Conventions

- Canonical name uses Title Case  
  Example: `Time To First Token`

- Acronyms included in parentheses on first mention  
  Example: `TTFT (Time To First Token)`

- Use singular form for term names  
  Example: `Warm Pool` (not `Warm Pools`)

---

## Cross-Referencing

- Always list at least **2 related terms** when applicable  
- Prefer linking to internal glossary entries  
- Avoid circular definitions

