# Priority Class

## Definition
A Priority Class defines the relative importance of workloads and determines which ones should run first and which ones can be preempted when resources are scarce.

It assigns a numeric priority to pods or jobs. Higher values mean higher importance.

Priority influences both admission order and preemption decisions.

## Why it matters in GPUaaS
GPU capacity is limited and expensive. When demand exceeds supply, the platform must decide:

- which workloads start first
- which ones wait
- which ones can be interrupted or reclaimed

Without priorities:
- critical jobs may be blocked by low-value workloads
- SLAs cannot be enforced
- reclaim becomes unsafe or random

Priority classes provide predictable, policy-driven ordering.

## Responsibilities
- order workloads during admission
- influence scheduling preference
- enable safe preemption of lower-priority workloads
- support tiered service levels (prod vs best-effort)

## Typical usage
Common tier mapping:

- high → production / SLA-bound
- medium → standard
- low → best-effort / background

When capacity is limited:
- higher priority jobs run first
- lower priority jobs may wait or be evicted

## Example
Cluster has 8 GPUs.

- a low-priority batch job is using all 8
- a high-priority production job arrives

With priority classes:
- the batch job can be preempted
- GPUs are reclaimed
- the production job starts

Without priorities:
- the production job would wait

## Mental model
Priority Class is the “importance label” on workloads that tells the system who goes first when resources are constrained.

## Related terms
- [Admission Control](./admission-control.md)
- [Preemption](./preemption.md)
- [Queue](./queue.md)
- [Fairness](./fairness.md)
- [Quota](./quota.md)

