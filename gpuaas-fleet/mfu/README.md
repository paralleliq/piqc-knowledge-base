# Model FLOP Utilization (MFU)

Model FLOP Utilization (MFU) measures how efficiently a model converts allocated GPU capacity into useful computation.

For tenants, MFU reflects **model efficiency**.  For GPUaaS providers, MFU reflects **economic efficiency**.

In a model-aware control plane, MFU is not just an observability metric — it becomes a policy signal.

---

## Why MFU Matters

GPU utilization alone does not tell the full story.

A GPU can appear “busy” while performing inefficient computation, suffering from pipeline stalls, suboptimal batch sizes, memory constraints, or communication bottlenecks.

MFU answers a more meaningful question:

> How much of the theoretical compute capability of the GPU is being converted into useful model FLOPs?

This makes MFU one of the most direct indicators of AI infrastructure efficiency.

---

## MFU in Context

At a high level:

```bash
MFU = Achieved Model FLOPs / Theoretical Peak GPU FLOPs
```

MFU differs from:

- **GPU Utilization (SM busy time)**  
- **Memory bandwidth utilization**  
- **Allocated GPU count**  
- **Cluster utilization percentage**

MFU focuses specifically on **useful mathematical work performed by the model**.

---

## Two Perspectives: Tenant vs Provider

### Tenant Perspective: Model Efficiency

For the tenant, MFU indicates:

- Whether batch size is optimal  
- Whether precision choice (FP16, BF16, FP8) is appropriate  
- Whether communication overhead is limiting throughput  
- Whether kernels are efficient  
- Whether inference or training is compute-bound or memory-bound  

Low MFU may signal configuration issues, under-batching, or model/runtime mismatch.

---

### Provider Perspective: Economic Efficiency

For a GPUaaS provider, MFU represents:

- Revenue-generating efficiency per allocated GPU  
- Hidden underutilization inside “fully allocated” nodes  
- Structural inefficiencies across model types  
- Fleet-level economic performance  

A fleet can show high allocation rates while still delivering poor effective compute output.  MFU bridges infrastructure metrics and financial outcomes.

---

## MFU Across Layers

MFU can be reasoned about at multiple levels:

| Level            | Meaning |
|------------------|----------|
| Workload MFU     | Efficiency of a specific model workload |
| Node MFU         | Effective compute efficiency of a GPU node |
| Fleet MFU        | Economic efficiency of the entire GPU fleet |

Understanding MFU across these layers enables more informed infrastructure decisions.

---

## MFU as a Control-Plane Signal

In a model-aware control plane, MFU is elevated from a dashboard metric to a policy input.  MFU can inform:

- Admission control decisions  
- Placement optimization (topology, NVLink vs PCIe, MIG shape)  
- Autoscaling strategies  
- Oversubscription policies  
- Economic efficiency monitoring  
- Drift detection between expected and observed performance  

The control plane does not merely observe MFU — it reasons about it.

---

## MFU and the Model-Aware Control Plane

Traditional schedulers operate on resource quantities:

- CPU
- Memory
- GPU count

A model-aware control plane introduces semantic awareness:

- Model architecture
- Batch size
- Parallelism strategy
- Runtime configuration
- Precision choice
- Communication pattern

MFU sits at the intersection of these layers.  It connects:

- Model intent  
- Runtime behavior  
- Infrastructure topology  
- Economic outcomes  

This makes MFU a foundational signal in intelligent GPU orchestration.  MFU represents the **efficiency dimension** of GPUaaS control-plane design.

---

## Related Documents

📂 [`mfu-control-plane-integration/`](./mfu-control-plane-integration.md)

📂 [`mfu-definition/`](./mfu-definition.md)

📂 [`mfu-provider-view/`](./mfu-provider-view.md)

📂 [`mfu-tenant-view/`](./mfu-tenant-view.md)

📂 [`mfu-vs-utilization/`](./mfu-vs-utilization.md)

---

## What This Section Covers

- MFU definition and conceptual grounding  
- Tenant and provider perspectives  
- MFU vs utilization  
- Measurement considerations  
- Control-plane integration concepts  

Implementation details, predictive models, and optimization strategies may extend beyond the scope of this public documentation.

---

## Strategic Framing

If Power Usage Effectiveness (PUE) measures data center infrastructure efficiency, MFU measures AI compute efficiency.

As AI-native infrastructure evolves, MFU becomes a first-class metric for both performance and economics.
