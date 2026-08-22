## Data Parallelism

**Definition**

A distributed execution strategy where multiple full copies of a model run on separate GPUs, each handling a different slice of requests (or training batch), rather than splitting a single model across devices.

**Why it exists**

Some models fit entirely within a single GPU's memory, so the goal of distributing them isn't to make a single copy fit — it's to scale throughput or training speed by running more copies in parallel. Data parallelism is the simplest way to do that: replicate the whole model, split the workload, run copies independently.

**Where in the stack**

Distributed parallelism

**Key properties**
- Each replica holds a full copy of the model — no communication needed for a single forward/decode pass
- Scales throughput close to linearly with replica count for inference, since replicas serve independent requests
- In training, requires gradient synchronization (all-reduce) across replicas after each step, unlike inference
- Distinct from tensor and pipeline parallelism, which split a single model instance across devices because it doesn't fit on one
- Combines with tensor/pipeline parallelism in large deployments — data-parallel groups of tensor-parallel replicas is a common pattern

**Common pitfalls**
- Assuming data parallelism helps when a model doesn't fit on one GPU — it doesn't; that's what tensor/pipeline parallelism solve
- Under training, all-reduce communication overhead between replicas can dominate step time if the network fabric is the bottleneck
- Autoscaling logic that doesn't distinguish data-parallel inference replicas from tensor-parallel shards of one logical deployment double-counts or undercounts effective capacity
- Load imbalance across replicas (uneven request routing) wastes the throughput gain the replication was meant to provide
- Conflating "more replicas" with "more capacity" without checking whether KV cache, not compute, is the actual constraint being relieved

**Related terms**
- Tensor parallelism
- Pipeline parallelism
- All-reduce
- Collective communication
- Model parallelism
- Autoscaling

**In practice**

An inference deployment scaling from 2 to 4 replicas via data parallelism roughly doubles served request throughput with no cross-GPU communication overhead per request — a very different scaling curve from adding tensor-parallel shards to a single model instance.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
