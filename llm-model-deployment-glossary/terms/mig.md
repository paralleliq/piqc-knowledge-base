## MIG (Multi-Instance GPU)

**Definition**

An NVIDIA hardware feature (A100, H100, and newer) that partitions a single physical GPU into up to seven isolated instances, each with its own dedicated slice of compute, memory, and cache bandwidth.

**Why it exists**

A full datacenter GPU is often far more capacity than a single small model or low-traffic workload needs, but running multiple unrelated workloads on one GPU without isolation risks one tenant's memory pressure or compute burst degrading another's. MIG gives hardware-level isolation — each instance behaves like its own smaller GPU — so multiple workloads can share a physical device safely.

**Where in the stack**

GPU & Memory

**Key properties**
- Partitions both compute and memory, unlike MPS or time-slicing, which only share compute
- Fixed slice profiles (e.g., `1g.10gb`, `3g.40gb`) determine how much of the physical GPU's compute and HBM each instance gets
- Isolation is real, not cooperative — one instance's workload cannot starve or corrupt another's
- A pod running on a MIG slice is not running on a full GPU, even though `hardware.gpuType` may still report the underlying physical device
- Slice profile is fixed at GPU configuration time, not changeable per-request

**Common pitfalls**
- Comparing a MIG slice's utilization against a whole-GPU baseline — the slice's ceiling is a fraction of the physical device's capacity
- Sizing a model for a `1g.10gb` slice when its actual memory footprint (weights + KV cache) needs more, causing OOM that looks like a tier misplacement rather than a slice-mismatch
- Oversizing a slice for a small model, wasting isolated memory that a smaller profile would have used more efficiently
- Fact collection that reports `hardware.gpuType` without `hardware.migProfile` makes every MIG deployment look like a full-GPU deployment to monitoring and rules
- Confusing MIG's hardware partitioning with MPS's software-only compute sharing — the failure modes and correct remediations differ

**Related terms**
- MPS
- Time-slicing
- GPU HBM
- Tier misplacement
- Deployment role
- Hardware tier

**In practice**

A model deployed on a `1g.10gb` MIG slice on an A100 is running with roughly a seventh of the physical GPU's memory and compute — utilization and throughput rules calibrated against a full A100 baseline will misjudge it as underutilized or misplaced unless the slice profile is known.


---

*Part of the [PIQC Knowledge Base](https://github.com/paralleliq/piqc-knowledge-base), maintained by [Paralleliq](https://paralleliq.ai). Want to check your own cluster for this? [piqc](https://github.com/paralleliq/piqc) is a free, open-source, read-only GPU waste scanner.*
