# Fairness

## Definition
Fairness is the principle of distributing shared resources across tenants or workloads in a way that prevents starvation, monopolization, or noisy neighbors, while honoring priorities and service tiers.

It ensures that each tenant receives an appropriate share of the cluster over time.

In GPUaaS, fairness answers:
“Who gets how much of the fleet, and for how long?”

## Why it matters in GPUaaS
GPU clusters are multi-tenant and demand is often bursty. Without fairness:

- one tenant can monopolize all GPUs
- smaller tenants may starve indefinitely
- SLAs become unpredictable
- platform trust erodes

Fairness keeps the platform stable and predictable even under heavy contention.

## Responsibilities
- allocate capacity proportionally across tenants
- enforce quotas and limits
- prevent starvation
- balance priority with sharing
- maintain predictable access over time

## Typical approaches
Common fairness mechanisms include:
- per-tenant quotas
- weighted or proportional sharing
- priority-based ordering
- time-sliced access
- preemption of over-consuming workloads

Many systems combine these techniques.

## Example
Cluster has 16 GPUs.

- Tenant A requests 16
- Tenant B requests 16

With fairness:
- each might receive 8 GPUs
- or capacity is split according to weights or tiers

Without fairness:
- Tenant A could consume all 16
- Tenant B waits indefinitely

## Trade-offs
Strict fairness may reduce peak utilization, while aggressive sharing may increase contention. Platforms often balance fairness with efficiency and priority.

## Mental model
Fairness is the rulebook that ensures the shared GPU fleet is divided reasonably, so everyone gets a turn and no one dominates.

## Related terms
- [Quota](./quota.md)
- [Priority Class](./priority-class.md)
- [Preemption](./preemption.md)
- [ClusterQueue](./clusterqueue.md)
- [Admission Control](./admission-control.md)

