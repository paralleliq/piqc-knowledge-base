## Time-Slicing

**Definition**

The crudest form of GPU sharing between processes: each process is given exclusive access to the full GPU for a short time slice in rotation, with no memory isolation and no concurrent execution.

**Why it exists**

Some environments need to run more workloads than there are physical GPUs, without MIG's fixed partitioning or MPS's cooperative concurrent-execution model — and without requiring any special GPU hardware support beyond basic scheduling. Time-slicing is the fallback sharing mechanism: give each process the whole GPU in turn, purely sequentially, which works on virtually any GPU but leaves real performance on the table.

**Where in the stack**

GPU & Memory

**Key properties**
- Purely sequential — only one process actually executes on the GPU at any instant, unlike MPS's concurrent sharing
- No memory isolation between time-sliced processes, same as MPS but without even the concurrent-execution benefit
- Context-switch overhead between slices is pure overhead with no offsetting throughput gain
- The least efficient of the three sharing modes (MIG, MPS, time-slicing) but requires the least specialized support to enable
- Oversubscription — too many processes sharing one GPU via time-slicing — degrades every tenant's throughput as context-switch overhead accumulates

**Common pitfalls**
- Using time-slicing for latency-sensitive workloads, where waiting for a time slice adds unpredictable delay that neither MIG nor MPS would impose
- Oversubscribing a GPU with too many time-sliced processes, where context-switch overhead starts to dominate actual useful compute time
- Reading per-process GPU utilization without knowing time-slicing is active, since true utilization is capped by the time-slice allocation, not by the process's own demand
- Treating time-slicing as a substitute for MIG or MPS when workload characteristics (need for isolation, need for genuine concurrency) call for one of those instead
- Not tracking `deployment.gpuSharingMode` as a fact, making it impossible to distinguish oversubscription-driven slowdown from a genuine capacity or configuration problem

**Related terms**
- MIG
- MPS
- GPU HBM
- Noisy neighbor
- Deployment role
- Hardware tier

**In practice**

A GPU time-sliced across too many low-priority batch jobs shows each job's effective throughput degrading as more jobs are added, well before any single job's actual workload characteristics changed — the context-switch overhead of oversubscription, not demand, is the bottleneck.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
