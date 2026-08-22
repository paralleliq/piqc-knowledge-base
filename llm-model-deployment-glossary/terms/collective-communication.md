## Collective Communication

**Definition**

The broader family of operations (all-reduce, all-gather, broadcast, reduce-scatter) that coordinate data across multiple GPUs participating in the same distributed computation, as opposed to point-to-point communication between two devices.

**Why it exists**

Splitting a model's execution across GPUs — whether by tensor, pipeline, or data parallelism — only works if the devices can efficiently exchange the partial results each one computes. Collective communication libraries (NCCL being the dominant one for NVIDIA GPUs) implement these exchange patterns as optimized primitives so every parallelism strategy doesn't have to reinvent its own communication logic.

**Where in the stack**

Distributed parallelism

**Key properties**
- Encompasses several distinct operations: all-reduce (combine and distribute), all-gather (collect and distribute without combining), broadcast (one-to-all), reduce-scatter (combine and distribute in pieces)
- Different parallelism strategies rely on different collectives — tensor parallelism leans heavily on all-reduce, pipeline parallelism relies on point-to-point sends between adjacent stages
- Performance depends on the underlying interconnect (NVLink within a node, InfiniBand/RoCE across nodes) and topology-aware placement
- Implemented by libraries like NCCL that abstract the specific collective away from application code
- A shared dependency across otherwise very different distributed execution strategies

**Common pitfalls**
- Treating all collective operations as interchangeable when they have different cost profiles and different points on the critical path
- Placing communicating GPUs across nodes or racks without considering which collective pattern dominates the workload, and therefore which topology matters most
- Attributing low GPU utilization to compute or memory issues without first ruling out a collective communication stall
- Assuming collective communication overhead is fixed — it scales with GPU count and message size, and can become the dominant cost at high parallelism degrees
- Debugging distributed training or inference without visibility into per-collective timing, making communication stalls indistinguishable from compute stalls

**Related terms**
- All-reduce
- Tensor parallelism
- Pipeline parallelism
- Data parallelism
- Interconnect bandwidth
- InfiniBand / RoCE

**In practice**

NCCL is the collective communication library underneath most multi-GPU LLM serving and training on NVIDIA hardware — when a distributed job's step time regresses, checking NCCL-level collective timing is often the fastest way to tell whether the cause is compute, memory, or network.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
