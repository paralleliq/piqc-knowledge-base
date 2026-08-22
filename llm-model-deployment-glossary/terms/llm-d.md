## llm-d

**Definition**

A Kubernetes-native framework for distributed LLM inference that runs vLLM across disaggregated prefill and decode instances, with KV-cache-aware request routing across the cluster instead of within a single engine.

**Why it exists**

A single vLLM engine couples prefill (compute-heavy context processing) and decode (memory-bound token generation) in the same process, and routes requests without awareness of where relevant KV cache already lives. At cluster scale this leaves throughput on the table — prefill and decode have different resource profiles and scale independently, and a request can land on a replica that has to recompute a prefix another replica already cached. llm-d disaggregates prefill and decode into separate pod roles and adds a scheduler that routes requests toward instances with a relevant cache hit, coordinated through Kubernetes rather than inside one engine.

**Where in the stack**

Control plane / Orchestration (built on the execution layer — vLLM)

**Key properties**
- Splits inference into separate prefill and decode pod roles, each scaled independently
- Adds a cluster-level, KV-cache-aware scheduler that routes requests toward replicas already holding relevant cache
- Runs as a Kubernetes-native deployment layer on top of vLLM, not a replacement engine
- Requires transporting KV cache from prefill to decode instances across the network rather than reusing it in place
- A pod's role (prefill vs. decode) changes what "healthy" utilization looks like — the two roles have different resource signatures

**Common pitfalls**
- Monitoring and rules calibrated for a single combined engine misclassify prefill and decode pods against the same utilization baseline
- KV cache transport between prefill and decode instances adds a network dependency that single-engine deployments don't have — a stalled or dropped transfer collapses throughput with no obvious vLLM-level error
- Placing prefill and decode pods without regard to network topology (rack, NVLink) reintroduces the latency the disaggregation was meant to avoid
- Treating it as a drop-in vLLM replacement rather than an orchestration layer that assumes disaggregation-aware scheduling and topology facts
- Cluster-level cache-aware routing benefits are easy to lose if placement or autoscaling logic doesn't account for where cache already lives

**Related terms**
- Disaggregated prefill/decode
- LMCache
- KV cache
- vLLM
- Scheduler
- Tensor parallelism

**In practice**

Under llm-d, a prefill pod and a decode pod serving the same model show completely different utilization profiles even when both are healthy — rules built around a single combined-engine baseline need a `deployment.role` fact (prefill, decode, combined) to interpret either one correctly.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
