# Preemption

## Definition
Preemption is the process of evicting or stopping lower-priority workloads to free resources for higher-priority ones.

It allows the system to reclaim capacity dynamically when demand exceeds supply.

In simple terms: a more important job can take resources away from a less important one.

## Why it matters in GPUaaS
GPU capacity is scarce and expensive. When a high-priority or SLA-bound workload arrives, the cluster may not have free GPUs available.

Without preemption:
- critical jobs must wait
- SLAs are missed
- expensive GPUs may be stuck running low-value work

Preemption enables the platform to quickly reclaim GPUs from best-effort or lower-tier workloads to serve higher-value requests.

## Responsibilities
- identify lower-priority workloads that can be interrupted
- safely evict or stop them
- release their resources (GPUs, memory, nodes)
- allow higher-priority workloads to run immediately

## Typical behavior
When a high-priority workload cannot be admitted:
1. the system finds lower-priority workloads
2. selects victims according to policy
3. evicts or terminates them
4. admits the higher-priority workload

This is often combined with priority classes and quotas.

## Example
Cluster has 8 GPUs running a low-priority batch job.

A production training job requiring 8 GPUs arrives.

With preemption:
- the batch job is evicted
- GPUs are reclaimed
- the production job starts

Without preemption:
- the production job waits until the batch job finishes

## Trade-offs
Preemption improves responsiveness for important workloads but may:
- waste partial work from interrupted jobs
- reduce predictability for best-effort users

It is typically applied only to lower tiers.

## Mental model
Preemption is the “reclaim lever” that ensures important workloads are never blocked by less important ones.

## Related terms
- [Priority Class](./priority-class.md)
- [Admission Control](./admission-control.md)
- [Reclaim](./reclaim.md)
- [Quota](./quota.md)
- [Fairness](./fairness.md)

