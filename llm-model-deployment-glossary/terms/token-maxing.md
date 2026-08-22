## Token Maxing

**Definition**

A condition where requests consistently hit or approach a deployment's maximum context window, saturating KV cache utilization and degrading throughput for every concurrent request sharing that pod — not a technique, but a failure mode to detect and correct.

**Why it exists**

KV cache is a fixed, finite resource per GPU. When request context lengths push utilization toward its ceiling (commonly tracked at ≥90%), there's no headroom left to admit new sequences or extend existing ones without eviction, queuing, or rejection. Because this is a resource-saturation condition rather than a crash, it degrades silently — throughput drops for all concurrent requests on the pod well before anything alerts or restarts.

**Where in the stack**

GPU & Memory / Reliability & failure modes

**Key properties**
- Tracked via KV cache utilization percentage against a high-utilization threshold (commonly ≥90%)
- Scoped per workload/pod — one saturated pod degrades every request sharing its KV cache, not just the long-context one
- Distinct from OOM: the pod doesn't crash, it just serves everyone slower as cache pressure rises
- Driven either by genuine capacity mismatch (GPU tier too small for the traffic) or by upstream requests sending unexpectedly long prompts
- Ambiguous under cross-engine KV cache reuse (LMCache) — a pod's local KV cache utilization can look low while the shared pool it draws from is actually saturated

**Common pitfalls**
- Mistaking it for a compute bottleneck when it's a memory-capacity bottleneck — the fix is cache/memory headroom, not more GPU compute
- Fixing it by adding GPU compute tier alone without addressing max sequence length, quantization, or replica count, when those are cheaper levers
- Missing that the underlying long-context traffic is an application bug, not an infrastructure capacity gap
- Thresholds calibrated for local, single-engine KV cache misfiring (or failing to fire) once a shared cache layer like LMCache is in play
- Treating every high-utilization reading as urgent when some workloads intentionally run near this ceiling by design

**Related terms**
- KV cache
- LMCache
- Paged attention
- OOM
- Prefix caching
- Throughput optimization

**In practice**

A workload showing KV cache utilization sustained above 90% degrades throughput for every request sharing that pod, not just the long-context ones — the standard remediations are moving to a larger GPU tier, adding replicas, capping max sequence length, enabling KV cache quantization, or offloading cold cache entries via LMCache, roughly in order of how directly each expands the saturated resource.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
