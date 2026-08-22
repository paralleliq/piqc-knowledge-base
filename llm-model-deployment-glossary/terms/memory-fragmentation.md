## Memory Fragmentation

**Definition**

A condition where free GPU memory exists but is scattered in blocks too small or non-contiguous to satisfy a new allocation, even though the total free capacity would be enough if it were contiguous.

**Why it exists**

Requests of varying sequence length allocate and free KV cache memory at different times and in different amounts. Without a memory layout designed to tolerate this churn, freed memory leaves gaps that don't line up with what the next request needs, wasting capacity that technically exists but can't be used.

**Where in the stack**

GPU & Memory

**Key properties**
- Distinct from insufficient memory — the capacity is there, just not addressable as one block
- Grows worse over time under naive contiguous allocation as requests of varying length enter and leave
- Directly motivates paged attention's block-based allocation, which sidesteps the problem by allocating in small, fixed-size, non-contiguous pages
- Shows up as declining effective concurrency over a pod's uptime even when raw utilization metrics look stable
- Worsened by highly variable request lengths and long-tail context sizes

**Common pitfalls**
- Standard GPU memory-utilization metrics don't distinguish "used" from "unusable," so fragmentation hides behind numbers that look healthy
- Restarting a pod to "fix" degraded throughput actually works, which reinforces treating a capacity problem as a transient glitch instead of diagnosing the fragmentation
- Assuming more total VRAM solves fragmentation, when the actual fix is allocator design (paging) or eviction policy, not raw capacity
- Ignoring page/block size tuning, which trades bookkeeping overhead against fragmentation resistance
- Conflating fragmentation with genuine KV cache saturation (token maxing) — the remediations are different

**Related terms**
- Paged attention
- Block allocator
- KV cache
- GPU HBM
- Token maxing
- Continuous batching

**In practice**

A vLLM deployment without paged attention gradually loses effective concurrency over its uptime as varied request lengths fragment contiguous KV cache allocations — the same total memory serves fewer and fewer concurrent sequences until a restart resets the layout.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
