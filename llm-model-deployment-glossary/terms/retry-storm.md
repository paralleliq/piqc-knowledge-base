## Retry Storm

**Definition**

A feedback loop where clients retrying failed or timed-out requests add enough additional load to the already-struggling system to cause further failures, which triggers more retries, compounding rather than resolving the original problem.

**Why it exists**

Retries are a reasonable default response to a transient failure — but if the underlying cause is overload rather than a one-off glitch, every retry is more load on a system that's already failing under load. Without backoff or circuit-breaking, the client-side fix for reliability becomes the mechanism that turns a recoverable blip into a sustained outage.

**Where in the stack**

Reliability & Failure Modes

**Key properties**
- Self-reinforcing — failures cause retries, retries cause more load, more load causes more failures
- Especially severe with naive fixed-interval or no-backoff retry logic, since retries arrive in lockstep rather than spread out
- Often the accelerant behind a cascading restart rather than the initial cause — an isolated pod failure becomes a fleet-wide incident once client retries pile onto the remaining replicas
- Can outlast the original triggering issue — even after root cause is fixed, a large backlog of queued retries can keep the system saturated
- Mitigated by exponential backoff with jitter, request timeouts tuned to actual service behavior, and circuit breakers that stop sending traffic to a clearly failing target

**Common pitfalls**
- Client libraries with retry logic enabled by default and no backoff configured, discovered only once traffic is high enough for it to matter
- Assuming a spike in request volume during an incident reflects real user demand, when it's actually the same requests being retried multiple times
- Fixing the root cause (e.g., restarting the failing pod) without addressing the retry backlog, so the recovering system immediately gets re-saturated
- Retry logic implemented independently at multiple layers (client SDK, API gateway, load balancer) multiplying the effective retry rate beyond what any single layer intended
- Load testing that doesn't simulate realistic retry behavior under failure, missing this failure mode until it happens in production

**Related terms**
- Cascading restart
- Admission control
- Queueing delay
- Thrashing
- Head-of-line blocking
- Autoscaling

**In practice**

During a partial outage, observed request volume can spike well above normal traffic purely from retries — teams that scale up capacity to match that inflated number are provisioning for phantom demand instead of fixing the retry storm and the underlying failure it's amplifying.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
