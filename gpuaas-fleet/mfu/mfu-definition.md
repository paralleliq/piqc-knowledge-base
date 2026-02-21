# Model FLOP Utilization (MFU) — Definition

Model FLOP Utilization (MFU) measures how efficiently a model converts available GPU compute capacity into useful mathematical work.  It quantifies the fraction of theoretical peak FLOPs that are actually used for model computation.

---

## Formal Definition

At a high level:

```bash
MFU = Achieved Model FLOPs / Theoretical Peak GPU FLOPs
```

Where:

- **Achieved Model FLOPs**  
  The effective floating-point operations executed by the model per unit time.

- **Theoretical Peak GPU FLOPs**  
  The maximum floating-point throughput the GPU can deliver under ideal conditions, based on hardware specifications and precision mode.

MFU is typically expressed as a percentage.

---

## What MFU Measures

MFU captures:

- Effective tensor core utilization  
- Arithmetic intensity of the workload  
- Kernel efficiency  
- Impact of communication overhead  
- Parallel scaling efficiency  
- Memory-compute balance  

MFU reflects how close the workload operates to hardware limits.

---

## What MFU Does Not Measure

MFU does not directly measure:

- GPU allocation rate  
- SM active time alone  
- Memory utilization  
- Node health  
- Scheduler fairness  

It specifically measures useful model computation relative to hardware capability.

---

## Precision Awareness

Theoretical peak FLOPs depend on precision mode:

- FP32 peak
- FP16 peak
- BF16 peak
- FP8 peak
- INT8 (in inference contexts)

MFU must be interpreted relative to the precision actually used by the workload.  Comparing MFU across workloads requires normalization by precision mode.

---

## MFU in Training vs Inference

### Training

MFU reflects:

- Forward + backward pass efficiency  
- Gradient synchronization overhead  
- Parallelism efficiency  
- Batch size adequacy  

Scaling to more nodes often reduces MFU due to communication overhead.

---

### Inference

MFU reflects:

- Batch size and concurrency  
- Sequence length distribution  
- KV cache behavior  
- Tensor core saturation  

Low-concurrency inference often results in low MFU despite high allocation.

---

## Typical MFU Ranges (Contextual)

MFU varies widely depending on:

- GPU generation
- Model architecture
- Parallelism strategy
- Runtime implementation
- Batch size
- Communication topology

There is no universal “good” MFU value.  MFU must be interpreted relative to:

- Hardware class
- Workload type
- Scaling configuration
- Expected theoretical limits

---

## Relationship to Other Metrics

| Metric | What It Measures |
|--------|------------------|
| GPU Utilization | Activity (SM busy time) |
| Allocation Rate | Assigned GPUs |
| Memory Utilization | Memory pressure |
| MFU | Effective compute efficiency |

MFU focuses on productivity rather than activity.

---

## Why MFU Matters

MFU provides:

- A performance efficiency signal for tenants  
- An economic efficiency signal for providers  
- A diagnostic signal for runtime tuning  
- A scaling efficiency indicator  
- A control-plane input for intelligent orchestration  

In AI-native infrastructure, MFU becomes a first-class efficiency metric.

---

## Conceptual Summary

GPU utilization answers:

> Is the GPU busy?

MFU answers:

> Is the GPU operating near its compute potential?

Busy is not the same as efficient.  MFU measures efficiency.
