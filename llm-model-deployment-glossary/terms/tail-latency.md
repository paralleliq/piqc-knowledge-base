## Tail Latency

**Definition**

The latency experienced by the slowest fraction of requests (commonly measured as p95, p99, or p999) rather than the average — the number that determines how bad the worst user experience gets, not how good the typical one is.

**Why it exists**

Average latency can look excellent while a meaningful fraction of requests are unacceptably slow, and for user-facing LLM applications that tail is exactly what drives complaints and churn. Tail latency exists as a metric because averages systematically hide the failure modes that matter most operationally — a single stuck GPU, a queued request behind a long one, a cold-started replica.

**Where in the stack**

Performance & Metrics

**Key properties**
- Reported as percentiles (p95, p99, p999), each capturing progressively rarer but worse outcomes
- Driven by different root causes than average latency — head-of-line blocking, cold starts, KV cache eviction, GPU thermal throttling all show up in the tail first
- A single pathological condition (one slow replica, one saturated cache) can dominate the tail while leaving the average untouched
- The metric most SLAs are actually written against, since users notice their own worst experience, not the fleet average
- Requires per-request instrumentation to diagnose — aggregate throughput numbers can't explain a tail latency spike

**Common pitfalls**
- Optimizing for average latency or aggregate throughput while tail latency silently degrades — the two can move in opposite directions
- Treating a p99 spike as noise because it affects "only" 1% of requests, when at scale that's still a large absolute number of bad experiences
- Not separating tail latency by request class (short chat vs. long batch) hides that one class is dragging down the shared tail
- Diagnosing tail latency spikes as generic "capacity" issues instead of checking for head-of-line blocking, KV eviction, or a single degraded replica first
- Averaging tail latency across replicas or time windows, which smooths out exactly the spikes the metric exists to catch

**Related terms**
- Head-of-line blocking
- Queueing delay
- TTFT
- TPOT
- Inference latency cliff
- Cold start

**In practice**

A p50 latency that looks perfectly healthy alongside a spiking p99 usually points to a subset of requests hitting a specific pathological condition — a cold replica, KV cache eviction, or queueing behind an unusually long request — rather than a fleet-wide capacity problem.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
