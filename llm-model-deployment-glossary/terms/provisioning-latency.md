## Provisioning Latency

**Definition**

The time between an autoscaling decision to add capacity and that capacity actually being ready to serve traffic — covering node acquisition, container scheduling, model loading, and warm-up, not just the scaling decision itself.

**Why it exists**

Autoscaling systems can decide to add a replica instantly, but the replica isn't useful until a real GPU is allocated, the container is scheduled and started, model weights are loaded into GPU memory, and any warm-up completes. Provisioning latency is the real-world gap between "decided to scale" and "actually serving," and for large models it can be the dominant factor in whether autoscaling actually helps during a traffic spike.

**Where in the stack**

Control Plane / Orchestration

**Key properties**
- Composed of several sequential stages: infrastructure provisioning (node/GPU allocation), scheduling, model loading, and warm-up
- Scales with model size — larger models take meaningfully longer to load into GPU memory, directly inflating this number
- The key variable that determines whether scale-to-zero or aggressive scale-down is viable for a given latency tolerance
- Can exceed the duration of the traffic burst that triggered scaling, making the new capacity arrive too late to help
- Distinct from cold start in scope — cold start is what a request experiences; provisioning latency is the infrastructure-level timeline underlying it

**Common pitfalls**
- Autoscaling policies tuned around scaling decision time without accounting for the much larger provisioning latency that follows, causing new capacity to arrive after the burst has passed
- Assuming provisioning latency is constant across GPU types or cloud regions, when node availability and model size both vary it significantly
- Not distinguishing infrastructure-level provisioning latency (getting a GPU) from application-level readiness (model loaded and warmed up) when diagnosing slow scale-ups
- Underestimating model loading time for very large models, which can dominate total provisioning latency more than node acquisition does
- Retry storms or cascading restarts compounding the problem, since they generate demand for new capacity faster than it can be provisioned

**Related terms**
- Cold start
- Scale-to-zero
- Warm pool
- Autoscaling
- Model loading
- Scale-up latency

**In practice**

A traffic spike that lasts two minutes provides no real benefit from autoscaling if provisioning latency for a new replica running a 70B model takes five minutes — by the time the new capacity is ready, the burst that triggered it is already over.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
