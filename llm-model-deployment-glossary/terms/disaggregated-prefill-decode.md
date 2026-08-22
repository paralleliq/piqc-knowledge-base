## Disaggregated Prefill/Decode

**Definition**

An architecture that splits inference into separate pods (sometimes separate hardware entirely) for prefill and decode, instead of running both phases on the same combined engine instance.

**Why it exists**

Prefill is compute-bound and bursty; decode is memory-bandwidth-bound and steady. Running both on the same instance means each has to compete with the other for the same GPU, and neither can be tuned or scaled independently for its own resource profile. Disaggregation lets prefill-heavy and decode-heavy traffic each get hardware and scaling policy suited to their actual bottleneck, at the cost of having to transport KV cache between the two once prefill finishes.

**Where in the stack**

Control Plane / Orchestration (execution split across the execution layer)

**Key properties**
- Prefill and decode instances scale independently, each sized and autoscaled against its own bottleneck rather than a shared average
- Requires transporting the KV cache computed during prefill to the decode instance over the network — a mechanical problem shared with cross-engine cache reuse systems like LMCache
- llm-d and NVIDIA Dynamo/Grove are examples of frameworks implementing this pattern as a Kubernetes-native orchestration layer over vLLM
- A prefill pod and a decode pod serving the same model show fundamentally different utilization signatures even when both are healthy
- Placement (same rack, same node, NVLink vs. cross-node network) between prefill and decode instances directly affects cache-transport latency

**Common pitfalls**
- Evaluating prefill and decode pods against a single shared utilization baseline, misclassifying one or both as unhealthy
- A dropped or stalled KV cache transfer between prefill and decode instances collapses throughput to zero with no obvious error at the framework level
- Placing prefill and decode instances without regard to network topology reintroduces the latency the disaggregation was meant to eliminate
- Autoscaling one phase (say, prefill) without correspondingly scaling the other creates an imbalance where one phase becomes the bottleneck for the whole pipeline
- Missing `deployment.role` (prefill, decode, combined) as a fact makes every rule that reasons about utilization or throughput wrong for at least one of the two roles

**Related terms**
- Prefill
- Decode
- llm-d
- LMCache
- KV cache
- Chunked prefill

**In practice**

Under disaggregation, a decode pod runs at high, steady memory-bandwidth utilization while its paired prefill pod runs bursty, compute-heavy utilization — both are healthy, but a fact schema without a `deployment.role` marker has no way to tell that apart from genuine misconfiguration on either side.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
