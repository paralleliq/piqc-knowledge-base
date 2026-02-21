# MFU — Tenant View

From a tenant perspective, Model FLOP Utilization (MFU) reflects how efficiently a model converts allocated GPU capacity into useful computation.

For tenants running training or inference workloads, MFU answers a critical question:

> Am I getting the maximum performance per GPU that I am paying for?

---

## What MFU Tells a Tenant

MFU exposes whether inefficiency originates from:

- Model configuration
- Runtime setup
- Parallelism strategy
- Batch size selection
- Precision choice
- Communication overhead
- Memory constraints

A tenant may see:

- High GPU utilization
- Stable memory usage
- No obvious runtime errors

Yet still observe low MFU.  That gap often represents wasted compute budget.

---

## Common Causes of Low MFU

### 1️⃣ Small Batch Size

- Underutilized tensor cores
- Insufficient arithmetic intensity
- GPU appears active but not saturated

Typical signal:
- High utilization
- Low achieved FLOPs
- Low MFU

---

### 2️⃣ Communication Bottlenecks

In distributed training:

- All-reduce overhead
- Gradient synchronization delays
- Imbalanced rank performance
- Slow interconnect (PCIe vs NVLink)

Signal:
- GPUs stall waiting on synchronization
- MFU drops even though GPUs are allocated

---

### 3️⃣ Data Pipeline Starvation

- Slow data loaders
- Inefficient preprocessing
- I/O bottlenecks
- Storage latency

Signal:
- Intermittent GPU idling
- MFU fluctuates over time

---

### 4️⃣ Memory-Bound Workloads

- Low arithmetic intensity
- Frequent memory stalls
- Suboptimal kernel fusion

Signal:
- High memory utilization
- Low effective FLOP throughput

---

### 5️⃣ Precision or Kernel Mismatch

- Using FP32 when BF16/FP16 would suffice
- Missing tensor-core optimization
- Non-optimized custom kernels

Signal:
- Utilization high
- MFU lower than expected for hardware class

---

## Training vs Inference MFU

MFU characteristics differ across workload types.

### Training

MFU is influenced by:

- Data parallelism efficiency
- Model parallelism strategy
- FSDP / ZeRO / tensor parallel overhead
- Gradient accumulation
- Micro-batch sizing

Training MFU often decreases as:
- Node count increases
- Communication overhead rises

---

### Inference

MFU is influenced by:

- Batch size
- Concurrency
- KV cache efficiency
- Request variability
- Sequence length distribution

Low-concurrency inference workloads often show:

- High allocation
- Low MFU
- High cost per token

---

## Why MFU Matters Financially for Tenants

Tenants typically pay for:

- GPU-hours
- Reserved capacity
- Provisioned nodes

Low MFU means:

- Higher cost per training step
- Higher cost per token
- Longer training time
- Lower throughput per dollar

Improving MFU can:

- Reduce training time
- Increase tokens/sec
- Lower cost per model iteration
- Improve SLA stability

---

## MFU as a Feedback Loop

For tenants, MFU should be part of a continuous optimization cycle:

1. Define workload intent  
2. Measure observed MFU  
3. Compare against expected hardware capability  
4. Adjust configuration  
5. Re-measure  

This creates an iterative performance tuning loop.

---

## What Good Looks Like

There is no universal “good” MFU.

It depends on:

- GPU generation (A100 vs H100 vs MI300)
- Model architecture
- Precision format
- Parallelism method
- Workload type

However, tenants should track:

- MFU consistency over time
- MFU across model versions
- MFU across hardware classes
- MFU across cluster sizes

Drift in MFU often indicates:

- Configuration regressions
- Scaling inefficiencies
- Infrastructure constraints

---

## Tenant Questions to Ask

- Is my MFU consistent across GPU types?
- Does MFU degrade as I scale out?
- Is inference MFU limited by batch size or request variability?
- Am I memory-bound or compute-bound?
- Is my cost per token aligned with expected MFU?

---

## Relationship to the Control Plane

In a model-aware control plane, MFU can support tenants by:

- Highlighting configuration inefficiencies
- Identifying scaling bottlenecks
- Suggesting placement strategies
- Exposing performance drift

MFU becomes more than a metric — it becomes a tuning signal.

---

## Summary

From the tenant perspective:

- GPU utilization tells you if the GPU is busy.
- MFU tells you if the model is efficient.
- Cost per token reflects the outcome.

Tenants that monitor MFU systematically can:

- Improve throughput
- Reduce infrastructure cost
- Scale more predictably
- Avoid hidden performance regressions
