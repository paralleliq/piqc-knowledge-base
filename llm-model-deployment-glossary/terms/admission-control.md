## Admission Control

**Definition**

The policy layer that decides whether a newly arrived request is accepted into the running batch immediately, queued, or rejected — based on current memory pressure, active sequence count, or fairness constraints.

**Why it exists**

Without admission control, a scheduler would try to admit every request as soon as it arrives, regardless of whether the GPU has KV cache headroom to support it. That guarantees OOM under load. Admission control is what keeps a serving engine from promising more concurrent capacity than it can actually deliver.

**Where in the stack**

Scheduling & Admission

**Key properties**
- Runs continuously, evaluated at every scheduling step under continuous batching, not just at connection time
- Typically gates on KV cache headroom, active sequence count, or a configured maximum concurrency
- Determines whether an arriving request enters the batch this step, waits in queue, or is rejected outright
- Can be fairness-aware (round-robin across tenants) or purely throughput-maximizing (first-fit, whatever admits fastest)
- Directly shapes queueing delay — an overly conservative policy under-utilizes the GPU; an overly aggressive one risks OOM or throughput collapse under load

**Common pitfalls**
- No explicit policy configured means the framework default applies, which may not match the workload's fairness or latency requirements
- Overly permissive admission thresholds work fine at low traffic and then OOM under a burst, since the failure only shows up at load
- Overly conservative thresholds leave GPU capacity idle that headroom would actually support, appearing as underutilization
- Admission decisions that don't account for request-declared max output length underestimate the KV cache a request will eventually need
- Multi-tenant deployments without per-tenant admission fairness let one noisy tenant starve others of admission slots

**Related terms**
- Scheduler
- Active sequences
- Queueing delay
- Head-of-line blocking
- KV cache
- Continuous batching

**In practice**

A vLLM deployment tuned with too permissive an admission threshold serves fine under normal load and then hits GPU OOM during a traffic spike — the fix is tightening the admission policy's headroom margin, not adding GPU memory, since the same spike would eventually exhaust any fixed capacity.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
