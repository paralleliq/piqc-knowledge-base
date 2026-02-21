# MFU vs GPU Utilization

GPU utilization and Model FLOP Utilization (MFU) are often confused.

They are related — but they measure fundamentally different things.

Understanding the distinction is critical for both tenants and GPUaaS providers.

---

## GPU Utilization

GPU utilization typically measures:

- Percentage of time Streaming Multiprocessors (SMs) are active
- Kernel execution occupancy
- Device-level activity

It answers the question:

> Is the GPU busy?

Example:

SM Utilization: 92%
Memory Utilization: 76%


A high utilization number means the GPU is not idle.  It does **not** guarantee efficient computation.

---

## Model FLOP Utilization (MFU)

MFU measures:

> How much of the theoretical peak GPU FLOPs are being converted into useful model computation.

At a high level:

```bash
MFU = Achieved Model FLOPs / Theoretical Peak GPU FLOPs
```

MFU answers a deeper question:

> Is the GPU doing useful model math efficiently?

---

## Why High Utilization ≠ High MFU

A GPU can be “busy” but inefficient.

Examples:

### 1️⃣ Small Batch Size
- GPU is active
- Underutilized tensor cores
- Low effective FLOP throughput
- High utilization, low MFU

### 2️⃣ Pipeline Stalls
- Communication delays
- All-reduce bottlenecks
- Data loader starvation
- GPU appears busy but productive compute is limited

### 3️⃣ Memory-Bound Workloads
- High memory activity
- Low arithmetic intensity
- SMs not performing peak FLOPs

### 4️⃣ Fragmented MIG Allocation
- GPU slices active
- Tensor core density suboptimal
- High allocation, reduced effective compute

In each case:
- Utilization can look healthy
- MFU reveals inefficiency

---

## Relationship Between MFU and Utilization

In most cases:

```bash
MFU ≤ GPU Utilization
```

Utilization measures activity.  MFU measures effective math.  However, the two metrics are not linearly correlated.

Two workloads with identical GPU utilization can have very different MFU.

---

## Tenant Perspective

From a tenant viewpoint:

| Metric | Meaning |
|--------|----------|
| GPU Utilization | Are my GPUs idle? |
| MFU | Is my model configured efficiently? |

A tenant may observe:

- 85% GPU utilization  
- 42% MFU  

This suggests configuration or architectural inefficiencies.

---

## Provider Perspective

From a GPUaaS provider viewpoint:

| Metric | Meaning |
|--------|----------|
| Allocation Rate | Are GPUs assigned? |
| GPU Utilization | Are GPUs active? |
| MFU | Are GPUs economically efficient? |

A fleet can show:

- 90% allocation  
- 88% utilization  
- 45% fleet MFU  

This indicates hidden revenue inefficiency.

MFU exposes compute productivity — not just activity.

---

## Why Both Metrics Matter

GPU utilization is useful for:

- Detecting idle GPUs
- Identifying obvious underuse
- Monitoring runtime health

MFU is useful for:

- Measuring model efficiency
- Identifying configuration drift
- Detecting economic inefficiency
- Informing control-plane decisions

They complement each other.  They are not interchangeable.

---

## Control-Plane Implication

A traditional scheduler reacts to:

- Resource requests
- Allocation
- Capacity availability

A model-aware control plane reasons about:

- Expected MFU
- Observed MFU
- Drift between intent and execution
- Economic impact of inefficiency

Utilization keeps GPUs busy.
MFU keeps GPUs productive.

---

## Summary

| Aspect | GPU Utilization | MFU |
|--------|------------------|------|
| Measures | Activity | Effective compute efficiency |
| Unit | % SM busy time | % of theoretical FLOPs |
| Indicates | Busyness | Productivity |
| Economic relevance | Indirect | Direct |
| Control-plane relevance | Operational | Strategic |

In AI-native infrastructure, MFU becomes a first-class metric alongside utilization.

Utilization answers: *Are we busy?*  
MFU answers: *Are we efficient?*
