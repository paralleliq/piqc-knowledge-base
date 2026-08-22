## Head-of-Line Blocking

**Definition**

A queueing condition where a request at the front of the line blocks requests behind it from being served, even though the resources those later requests need are available.

**Why it exists**

Naive request scheduling processes queued work in strict arrival order. If the first request in line is unusually expensive — a very long prompt, a very long requested output — everything behind it waits for it to finish, even if the GPU has capacity to serve the smaller requests behind it concurrently. Continuous batching and smarter scheduling exist specifically to avoid this failure mode.

**Where in the stack**

Scheduling & Admission

**Key properties**
- Occurs when strict FIFO ordering couples an expensive request's completion time to unrelated requests' start time
- Static batching is especially prone to it — the whole batch waits for its slowest member
- Continuous batching largely eliminates it at the batch level by admitting and evicting sequences independently at every step
- Can still occur at the admission-queue level even under continuous batching, if the admission policy itself is strict FIFO
- Shows up as high tail latency for short requests specifically when they happen to queue behind long ones

**Common pitfalls**
- Assuming continuous batching alone eliminates head-of-line blocking everywhere in the stack, when the admission queue in front of it can still block strictly by arrival order
- Diagnosing tail latency spikes as a capacity problem when the actual cause is queue ordering, not insufficient GPU resources
- Fair-queueing or priority-aware admission policies exist to address this, but require deliberate configuration — it's not automatic
- Mixed-workload deployments (long-context batch jobs alongside latency-sensitive chat traffic) are especially prone to this without explicit request-class separation
- Not measuring queueing delay separately from service time makes head-of-line blocking invisible in aggregate latency metrics

**Related terms**
- Queueing delay
- Admission control
- Continuous batching
- Fair scheduling
- Tail latency
- Scheduler

**In practice**

A chat-latency-sensitive endpoint sharing an admission queue with long batch-summarization requests can see its p99 latency spike whenever a large request happens to queue ahead of a small one — the fix is priority-aware admission or separate queues per request class, not more GPU capacity.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
