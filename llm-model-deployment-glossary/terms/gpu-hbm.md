## GPU HBM

**Definition**

High Bandwidth Memory — the memory technology stacked directly on modern datacenter GPUs (A100, H100, and similar) that holds model weights, KV cache, and activations, sized and speed-constrained in ways that shape almost every LLM serving decision.

**Why it exists**

LLM inference is dominated by moving large amounts of data (weights, then KV cache) in and out of memory for every forward pass. HBM exists specifically to give GPUs the memory bandwidth this workload demands — far higher than conventional DRAM — but it comes in fixed, expensive capacities per device, which is why HBM capacity, not raw compute, is usually the binding constraint on how many requests a GPU can serve.

**Where in the stack**

GPU & Memory

**Key properties**
- Fixed capacity per GPU (e.g., 80GB on an H100), shared between model weights, KV cache, and activation memory
- Bandwidth, not just capacity, gates decode-phase throughput — decode is memory-bandwidth-bound, not compute-bound
- Model weights consume a fixed HBM budget regardless of traffic; KV cache is the variable, traffic-dependent consumer
- Insufficient HBM headroom is the direct cause of OOM and forces smaller batch sizes, shorter max context lengths, or a larger GPU tier
- MIG partitions HBM (and compute) into isolated slices, so a MIG slice's usable HBM is a fraction of the physical GPU's total

**Common pitfalls**
- Sizing decisions based on GPU compute (FLOPs) tier alone, ignoring that HBM capacity is what actually constrains concurrent request count
- Not accounting for the fixed weight footprint when estimating how much HBM is actually available for KV cache
- Assuming quantizing weights alone solves memory pressure when KV cache, not weights, is the dominant consumer under high concurrency
- Treating HBM bandwidth and HBM capacity as the same constraint — a workload can be capacity-rich but bandwidth-starved, or vice versa
- Comparing utilization across GPU tiers without normalizing for each tier's different HBM capacity and bandwidth

**Related terms**
- KV cache
- Memory fragmentation
- MIG
- Token maxing
- OOM
- GPU memory bandwidth saturation

**In practice**

A 70B model consumes a large, fixed share of an H100's 80GB HBM in weights alone before a single request arrives — the remaining headroom is what's actually available for KV cache, and that's the number that determines real concurrent-request capacity, not the GPU's advertised memory total.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
