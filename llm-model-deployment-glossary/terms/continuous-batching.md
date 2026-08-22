## Continuous Batching

**Definition**

A scheduling technique that dynamically adds and removes sequences from a running batch at every decoding step, instead of waiting for a fixed batch to fully finish before starting the next one.

**Why it exists**

Static batching groups requests together and waits for every sequence in the batch to finish before admitting new ones — a single long sequence holds the whole batch hostage while shorter, finished sequences leave GPU capacity idle. Continuous batching (also called iteration-level scheduling) evicts finished sequences and admits new ones at every step, keeping the GPU consistently full.

**Where in the stack**

Serving layer / Scheduling

**Key properties**
- Operates at the granularity of individual decode steps, not whole requests
- New requests can join a running batch as soon as a slot frees up, not just at batch boundaries
- Requires per-sequence KV cache management (typically paged attention) to support sequences entering and leaving independently
- Dramatically improves GPU utilization and throughput compared to static batching under mixed sequence lengths
- Effective batch size varies step to step rather than being fixed

**Common pitfalls**
- Without paged attention or similar memory management, continuous batching still fragments memory as sequences of different lengths enter and leave
- A burst of long-context admissions can starve throughput for concurrently running short sequences
- Naive implementations recompute scheduling decisions every step, adding CPU-side overhead at high request rates
- Metrics dashboards built around fixed batch size misread throughput swings as anomalies rather than normal variation
- Admission policy (fairness vs. throughput-maximizing) is easy to leave unconfigured and defaults to whichever the framework ships with

**Related terms**
- Paged attention
- Batching
- Active sequences
- KV cache
- Scheduler
- Throughput optimization

**In practice**

vLLM's scheduler uses continuous batching by default — a long-running sequence never blocks new short requests from being admitted, which is why vLLM sustains high throughput under highly variable request lengths where static-batching engines stall.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
