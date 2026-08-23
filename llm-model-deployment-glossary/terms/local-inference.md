## Local Inference (On-Device / Edge Inference)

**Definition**

Running LLM inference directly on the end user's own hardware — laptop, phone, or workstation — instead of sending the request to a centralized cloud or data-center GPU fleet.

**Why it exists**

Every cloud inference request costs network round-trip latency, ongoing per-query cloud spend, and a data-governance boundary the request has to cross. As small models (≤20B active parameters) have closed much of the capability gap with frontier cloud models on easier tasks, running those models directly on local hardware — laptops with unified memory, phones with NPUs — became viable for a real share of everyday queries, avoiding all three costs for the queries it can handle.

**Where in the stack**

Control Plane / Orchestration (deployment topology)

**Key properties**
- Bounded by the local device's memory capacity, not by cloud-scale infrastructure — a device can only host a model (or, for MoE, only as many total experts) as its memory allows
- Eliminates network round-trip latency and per-query cloud cost entirely for queries it handles
- Keeps data on-device, which matters for privacy-sensitive or offline use cases independent of any performance argument
- Capability generally trails frontier cloud models on harder tasks — coverage is strongest on short, single-turn chat and reasoning queries, weaker on complex or long-context work
- Improving quickly: local model win-rate against frontier models on single-turn tasks rose from roughly 23% (2023) to over 70% (2025) per published benchmarks, though those benchmarks are themselves short-context and single-turn

**Common pitfalls**
- Treating local-model benchmark wins on short, single-turn tasks as evidence it can replace cloud inference for long-context, multi-turn, or agentic workloads, which weren't part of those benchmarks
- Assuming "runs locally" means "runs on commodity hardware" — the strongest local results often depend on high-memory devices (128GB+ unified memory), not typical consumer laptops or phones
- Ignoring that MoE models decouple compute from memory but not memory from *capability* — a locally-hostable MoE model is still capped by what the device can hold in total, however efficient its active-parameter compute is
- Conflating local inference's efficiency argument (real, and well-supported) with a wholesale replacement argument for cloud infrastructure (a much larger claim the same evidence doesn't support)
- Not distinguishing genuinely offline local inference from hybrid local-cloud routing, which is a different architecture with different failure modes

**Related terms**
- Hybrid local-cloud routing
- Mixture of Experts
- Quantization
- GPU HBM
- Autoscaling
- Scale-to-zero

**In practice**

A laptop or phone running a quantized 8B-parameter local model can handle routine chat and simple reasoning queries entirely offline with no cloud round-trip; the same device is not a substitute for a cloud-hosted frontier model on long-document analysis, multi-step agentic tool use, or anything requiring context beyond what the local model's window and capability can cover.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
