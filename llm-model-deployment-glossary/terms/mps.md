## MPS (Multi-Process Service)

**Definition**

An NVIDIA GPU feature that allows multiple processes to share a single GPU's compute concurrently, time-multiplexing execution without the hard memory and compute isolation that MIG provides.

**Why it exists**

Not every workload sharing a GPU needs, or can justify the fixed overhead of, MIG's hardware-level partitioning. MPS gives a lighter-weight way to run multiple processes on one GPU concurrently, useful when workloads are trusted to share cooperatively and don't need strict isolation between them.

**Where in the stack**

GPU & Memory

**Key properties**
- Shares GPU compute across processes without partitioning memory the way MIG does — all processes draw from the same memory pool
- Lower overhead and more flexible allocation than MIG, since there's no fixed slice profile to commit to upfront
- No hard isolation — one process's memory pressure or compute burst can degrade another's performance (a noisy-neighbor risk MIG is specifically designed to prevent)
- Utilization readings under MPS reflect combined activity across all sharing processes, not any one workload alone
- A softer, more cooperative sharing model than MIG, appropriate when workloads are known to be compatible rather than adversarial or unpredictable

**Common pitfalls**
- Assuming MPS provides the same isolation guarantees as MIG, when memory pressure from one process can directly affect others sharing the GPU
- Interpreting per-process utilization metrics without knowing MPS is active, misreading combined GPU activity as belonging to a single workload
- Deploying latency-sensitive workloads under MPS alongside bursty or unpredictable ones, exposing the latency-sensitive workload to noisy-neighbor effects
- Not tracking `deployment.gpuSharingMode` as a fact, making MPS-related utilization anomalies indistinguishable from genuine misconfiguration
- Confusing MPS with time-slicing — MPS allows genuinely concurrent execution across processes; time-slicing is a cruder, purely sequential sharing mechanism

**Related terms**
- MIG
- Time-slicing
- GPU HBM
- Noisy neighbor
- Deployment role
- Hardware tier

**In practice**

Two models sharing a GPU under MPS can each show moderate utilization individually while the underlying GPU is fully saturated in aggregate — utilization-based tier misplacement checks that don't know MPS is active will misjudge either workload as underutilized when the GPU as a whole is fully loaded.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
