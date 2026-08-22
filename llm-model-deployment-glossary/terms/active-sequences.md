## Active Sequences

**Definition**

The set of requests currently occupying KV cache and participating in the running batch at a given point in time — the real-time measure of how much concurrent work a serving instance is handling.

**Why it exists**

Request rate alone doesn't tell you how loaded a deployment is — a few long-running sequences can consume as much KV cache as many short ones. Active sequence count is the concrete, moment-to-moment number that determines whether there's room to admit another request, and it's what admission control and continuous batching actually operate on.

**Where in the stack**

Scheduling & Admission

**Key properties**
- Changes every scheduling step under continuous batching, as sequences finish and new ones are admitted
- Directly bounded by available KV cache — more active sequences means more concurrent memory consumption, not just more CPU-side bookkeeping
- A better real-time load signal than raw request-per-second rate, since sequence length varies widely
- The denominator admission control implicitly reasons about when deciding whether to admit a new request
- Distinct from queue depth — active sequences are already running; queued requests are waiting for a slot

**Common pitfalls**
- Sizing capacity around average request rate instead of peak active sequence count under bursty or long-tail-length traffic
- Assuming low active sequence count always means underutilization, when it can also mean each active sequence is very long (KV-cache-heavy) and the GPU is actually near capacity
- Monitoring that reports request throughput but not active sequence count misses the signal that actually predicts imminent OOM or admission rejection
- Not accounting for active sequence count per pod when reasoning about fleet-level load balancing — two pods with equal request rates can have very different active sequence loads
- Conflating active sequences with concurrent connections at the HTTP layer, which can be much higher if many connections are idle or streaming slowly

**Related terms**
- Admission control
- Continuous batching
- KV cache
- Queue depth
- Effective batch size
- Scheduler

**In practice**

Two pods serving the same request rate can have very different active sequence counts if one is handling long-context requests and the other short ones — the long-context pod is closer to KV cache saturation even though its request throughput looks identical.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
