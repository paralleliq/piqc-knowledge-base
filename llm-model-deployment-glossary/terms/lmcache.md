## LMCache

**Definition**

A KV cache reuse layer that extends prefix caching beyond a single engine instance — sharing computed KV cache across engine replicas and across storage tiers (GPU memory, CPU RAM, local disk, remote store) instead of recomputing or discarding it.

**Why it exists**

Native prefix caching only reuses KV cache within one engine instance, and only in GPU memory. In multi-replica deployments, every replica recomputes the same shared context independently, and cache is lost the moment an engine evicts it or restarts. LMCache generalizes cache reuse across engines and across storage tiers, trading some retrieval latency for a much larger effective cache than GPU memory alone can hold.

**Where in the stack**

Execution layer / Memory management (cross-engine)

**Key properties**
- Extends KV cache reuse across engine instances, not just within one
- Offloads cache to CPU RAM, local disk, or a remote store beyond GPU memory
- Same mechanical transport problem shows up in prefill/decode disaggregation, where the prefill instance's KV cache must reach the decode instance
- A pod's local KV cache utilization no longer reflects total cache pressure once a shared pool exists
- Improves prefix cache hit rate for workloads with repeated context across replicas
- Effectiveness depends on hit rate, not just whether it's enabled

**Common pitfalls**
- Enabled but earning nothing — overhead without a corresponding hit-rate gain
- Local GPU KV cache metrics read as healthy while the shared pool is under pressure
- Overprovisioning and misplacement checks read GPU memory pressure as artificially low once cache is offloaded
- Throughput baselines calibrated for standard single-engine caching under-predict headroom
- Cache tier misconfiguration (over-aggressive pinning, poor placement relative to compute) silently degrades retrieval latency

**Related terms**
- Prefix caching
- KV cache
- Paged attention
- Continuous batching
- Disaggregated prefill/decode
- vLLM

**In practice**

A deployment can show low local KV cache utilization per pod while the overall LMCache pool is saturated — rules and dashboards built for single-engine prefix caching will misread this as healthy capacity rather than cache pressure.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
