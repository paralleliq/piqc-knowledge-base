# Reclaim

## Definition
Reclaim is the process of taking back resources (such as GPUs or nodes) from lower-priority or best-effort workloads so they can be reassigned to higher-priority or more important workloads.

It allows the platform to dynamically reallocate scarce capacity based on policy and demand.

In simple terms: free resources by stopping or moving less important work.

## Why it matters in GPUaaS
GPU demand is unpredictable and capacity is limited. At times:

- premium tenants need immediate access
- SLAs must be met
- no free GPUs are available

Without reclaim:
- important workloads must wait
- SLAs are violated
- the platform cannot enforce tiers

Reclaim ensures that higher-value workloads can always obtain capacity when needed.

## Responsibilities
- identify reclaimable workloads (usually low priority or best-effort)
- select victims according to policy
- safely evict or terminate them
- release resources back to the pool
- allow higher-priority workloads to proceed

Reclaim is typically coordinated with admission control and preemption.

## Typical behavior
1. high-priority workload arrives
2. no free GPUs available
3. system finds lower-priority jobs
4. evicts or stops them
5. GPUs become available
6. new workload is admitted

This enables fast response to urgent demand.

## Example
Cluster has 8 GPUs, all used by best-effort jobs.

A production job arrives needing 8 GPUs.

With reclaim:
- best-effort jobs are terminated
- GPUs are freed
- production job starts

Without reclaim:
- production job must wait

## Reclaim vs Preemption
These terms are closely related:
- **Preemption** → scheduler-level eviction decision
- **Reclaim** → broader control-plane action to free capacity

Reclaim may include preemption, draining, or migration.

## Trade-offs
Reclaim improves responsiveness but may:
- waste partially completed work
- reduce predictability for lower tiers

Platforms typically allow reclaim only for specific classes.

## Mental model
Reclaim is the “take-back lever” that ensures scarce GPU resources can be reallocated to where they matter most.

## Related terms
- [Preemption](./preemption.md)
- [Priority Class](./priority-class.md)
- [Admission Control](./admission-control.md)
- [Fairness](./fairness.md)
- [Quota](./quota.md)

