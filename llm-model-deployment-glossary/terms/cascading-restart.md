## Cascading Restart

**Definition**

A failure pattern where one pod restarting shifts its load onto remaining replicas, pushing them past their own limits and triggering further restarts, propagating instability across a deployment instead of containing it to the original failure.

**Why it exists**

When a replica goes down, its in-flight and incoming traffic has to go somewhere — usually the remaining replicas via load balancing or retries. If those replicas were already running close to their own memory or throughput limits, absorbing the extra load pushes them over, and the failure that took out one pod takes out the next one too. Nothing about a single pod restart is inherently dangerous; the cascade is what turns an isolated fault into a fleet-wide incident.

**Where in the stack**

Reliability & Failure Modes

**Key properties**
- Requires two conditions together: a triggering failure (OOM, crash, node eviction) and insufficient headroom on the remaining replicas to absorb redistributed load
- Each restart compounds the problem — fewer healthy replicas means more load per remaining replica, accelerating the cascade
- Retry storms often accompany or accelerate cascading restarts, as clients retry against an already-overloaded remaining fleet
- The interval between the first and subsequent restarts is a key diagnostic signal — a tight cluster of restarts across different pods points to cascade, not independent failures
- Prevention requires headroom margin per replica, not just fleet-level average capacity

**Common pitfalls**
- Diagnosing each restart independently rather than recognizing a fleet-wide cascade pattern from correlated timing across pods
- Running replicas near 100% capacity by design, leaving no margin to absorb load if any single replica fails
- Aggressive client-side retry logic without backoff amplifies the cascade by hammering the remaining healthy replicas hardest right when they're most fragile
- Autoscaling that reacts too slowly to add capacity once a cascade has started, since the cascade can outrun a scale-up's provisioning latency
- Rolling restarts or deployments performed without accounting for the reduced headroom during the rollout window, effectively inducing the same failure mode intentionally

**Related terms**
- Retry storm
- Pod restart
- Thrashing
- OOM
- Provisioning latency
- Autoscaling

**In practice**

A single OOM-killed pod in an under-provisioned fleet can trigger a cascade where each remaining replica absorbs enough extra load to OOM in turn — the timeline of tightly clustered restarts across different pods is the signature that distinguishes this from unrelated independent failures.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
