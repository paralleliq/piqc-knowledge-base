## All-Reduce

**Definition**

A collective communication operation that combines values (typically by summing) across all participating GPUs and distributes the combined result back to every participant, used to synchronize state across devices splitting the same computation.

**Why it exists**

Tensor parallelism, pipeline parallelism, and data-parallel training all need to combine partial results computed independently on different GPUs into one consistent value — partial attention outputs across tensor-parallel shards, or gradients across data-parallel replicas. All-reduce is the standard primitive for doing that combination efficiently across many devices at once, rather than routing everything through a single coordinator.

**Where in the stack**

Distributed parallelism

**Key properties**
- Every participating GPU ends up with the same combined result — not just one designated "reducer"
- Cost scales with both the data volume being reduced and the interconnect bandwidth between GPUs (NVLink intra-node, InfiniBand/RoCE inter-node)
- Sits on the critical path of every tensor-parallel forward pass — the model cannot proceed until the all-reduce completes
- A single slow or dropped participant stalls the entire group, not just its own shard
- Different topologies (ring, tree, hierarchical) trade latency against bandwidth efficiency depending on GPU count and interconnect

**Common pitfalls**
- A saturated or misconfigured network fabric makes all-reduce the actual bottleneck while GPU compute utilization reads low — the workload looks idle when it's actually stalled waiting on communication
- Placing tensor-parallel shards across nodes without regard to interconnect topology turns a fast intra-node NVLink all-reduce into a slow inter-node one
- Debugging low GPU utilization without checking network fabric health first, when the root cause is a stalled collective, not a compute or memory issue
- Assuming all-reduce cost is negligible at small tensor-parallel degrees — it scales, and can dominate at high degrees or over slow interconnects
- One misbehaving or lagging GPU in the group silently degrades the whole cluster's step time, which is hard to attribute without per-GPU timing

**Related terms**
- Collective communication
- Tensor parallelism
- Data parallelism
- Interconnect bandwidth
- InfiniBand / RoCE
- NVLink

**In practice**

On a multi-node tensor-parallel deployment, a saturated InfiniBand fabric stalls the all-reduce every layer depends on — GPUs read as underutilized not because the workload is misconfigured, but because every GPU is waiting on the same slow collective operation.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
