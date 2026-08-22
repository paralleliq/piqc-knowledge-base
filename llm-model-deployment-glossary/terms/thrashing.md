## Thrashing

**Definition**

A degenerate state where a system spends more effort managing contention for a resource than doing useful work with it — repeatedly evicting and reloading KV cache blocks, or repeatedly restarting pods, without net progress.

**Why it exists**

Systems under sustained resource pressure don't always fail cleanly — sometimes they enter a loop where the corrective action (evict cache, restart a pod, reschedule a request) creates the same pressure again immediately, and the system spends its capacity cycling rather than serving. Naming this failure mode separately from simple overload matters because the fix is different: thrashing needs the cycle broken, not just more of the constrained resource.

**Where in the stack**

Reliability & Failure Modes

**Key properties**
- Distinguished from simple overload by the cycling pattern — resource is freed and immediately re-consumed, gaining no headroom
- Common in KV cache eviction: evicting one sequence's cache to admit another, only to immediately need to evict that one too as more requests arrive
- Can also occur at the pod level — a crash-loop where each restart hits the same OOM or resource contention that caused the last crash
- Symptoms often look like reduced effective throughput with normal-looking peak utilization metrics, since the system is "busy" but not productive
- Usually requires either reducing concurrent demand or increasing the constrained resource meaningfully, not marginally — a small increase can still thrash

**Common pitfalls**
- Reading high GPU or CPU utilization during thrashing as a sign of healthy load, when the work being done is churn rather than forward progress
- Adding a small amount of extra capacity as a fix, when thrashing often requires a larger margin to break the cycle rather than a marginal increase
- Treating each individual restart or eviction as an isolated event instead of recognizing a repeating pattern
- Not tracking eviction rate or restart frequency as first-class signals, which are what actually reveal thrashing versus normal variability
- Root-causing thrashing as a capacity problem when it's sometimes a scheduling or admission policy problem — better admission control can prevent the cycle without more resources

**Related terms**
- Cache eviction
- KV cache
- Cascading restart
- OOM
- Memory fragmentation
- Admission control

**In practice**

A deployment cycling through repeated KV cache evictions under sustained high concurrency can show flat or declining effective throughput even as GPU utilization metrics look saturated — the GPU is busy re-doing work it already did, not serving more requests.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
