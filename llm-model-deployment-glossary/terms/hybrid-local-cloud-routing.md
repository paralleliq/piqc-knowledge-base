## Hybrid Local-Cloud Routing

**Definition**

An architecture where a router classifies each incoming request and sends easier queries to a local or smaller model while routing harder queries to a cloud-hosted frontier model, instead of sending all traffic to a single tier.

**Why it exists**

Not every query needs a frontier model's capability, and not every query can be handled by a local model's more limited capability. Sending everything to the cloud pays frontier-model cost and latency for queries a much cheaper local model could have answered just as well; sending everything to a local model sacrifices quality on the harder queries that genuinely need it. Routing lets each request land on the tier that actually matches its difficulty.

**Where in the stack**

Control Plane / Orchestration

**Key properties**
- Router accuracy directly determines how much of the benefit is realized — published results show an 80%-accurate router captures roughly 80% of the savings a perfect (oracle) router would achieve
- Can deliver large aggregate reductions in cloud energy, compute, and cost — one published study measured 60-80% reductions versus an all-cloud baseline
- The router itself is an additional component with its own latency and failure modes, sitting on the critical path of every request
- Misrouted queries (easy queries sent to cloud, hard queries sent to local) waste the efficiency gain the architecture exists to capture
- Distinct from local inference alone — this is a dynamic, per-request architecture, not a static choice between one deployment or the other

**Common pitfalls**
- A cloud GPU serving only the router's harder, deflected queries shows lower utilization than it would under all-cloud traffic — a monitoring rule that doesn't know hybrid routing is active can misread this as underutilization or misplacement, the same failure mode already known for draft models in speculative decoding
- Router misclassification is silent — a hard query incorrectly routed to the local tier degrades quality without an obvious error, and an easy query incorrectly routed to cloud just wastes cost without failing
- Treating the router as a one-time classifier rather than something that needs its own accuracy monitoring and retraining as query patterns shift
- Underestimating the router's own latency contribution, which adds to every request regardless of which tier ultimately serves it
- Not accounting for data-governance implications of the split — the local and cloud tiers may have different compliance postures, and routing decisions can inadvertently cross a boundary that matters

**Related terms**
- Local inference
- Mixture of Experts
- Autoscaling
- Scheduler
- Quantization
- Admission control

**In practice**

A support-chat product routing routine FAQ-style questions to a local model and only escalating genuinely novel or complex questions to a cloud-hosted frontier model can cut cloud inference cost substantially — but the cloud-side GPU fleet serving the escalated traffic needs to be evaluated against a baseline that accounts for the router's deflection, not against an all-traffic baseline that assumes every request would otherwise have landed there.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
