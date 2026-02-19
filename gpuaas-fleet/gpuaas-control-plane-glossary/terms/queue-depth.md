# Queue Depth

## Definition
Queue depth is the number of workloads currently waiting in a queue for admission or scheduling.

It measures how much demand exceeds available capacity at a given time.

In GPUaaS systems, queue depth is one of the primary signals of contention and capacity pressure.

## Why it matters in GPUaaS
GPU resources are limited and slow to provision. When demand spikes:

- workloads accumulate
- admission is delayed
- users experience long wait times
- SLAs may be violated

Queue depth directly reflects this backlog.

It is often the earliest and most reliable indicator that the platform needs scaling, reclaim, or rebalancing actions.

## Responsibilities
Queue depth helps operators and control planes:

- detect congestion
- trigger scaling or provisioning
- prioritize workloads
- enforce fairness
- forecast demand
- identify under- or over-provisioning

It is commonly used in reconciliation and alerting rules.

## Typical behavior
When workloads are submitted:
1. they enter a queue
2. if capacity exists → admitted immediately
3. if not → they wait
4. waiting workloads increase queue depth

As capacity frees or scales up:
- depth decreases

## Example
Cluster has capacity for 10 jobs.

If 25 jobs are submitted:
- 10 run
- 15 wait

Queue depth = 15

This indicates backlog and potential need for more capacity.

## Common thresholds
Platforms often trigger actions based on depth:

- small depth → normal
- sustained growth → scale up
- very large depth → reclaim or prioritize
- near zero with idle GPUs → scale down

Depth trends are often more important than single values.

## Relationship to scaling
Queue depth is a common signal for:

- reactive scaling (pending pods → provision nodes)
- proactive scaling (growing backlog → pre-scale)
- admission gating (delay new workloads)
- fairness enforcement

It connects demand to provisioning decisions.

## Mental model
Queue depth is the “line length” of waiting workloads — the longer the line, the more pressure on the system.

## Related terms
- [Queue](./queue.md)
- [Admission Control](./admission-control.md)
- [Provisioning](./provisioning.md)
- [Reactive Scaling](./reactive-scaling.md)
- [Metrics](./metrics.md)

