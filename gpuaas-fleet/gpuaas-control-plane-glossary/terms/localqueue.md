# LocalQueue

## Definition
A LocalQueue is a per-tenant or per-namespace queue that represents the entry point where workloads are submitted and managed before admission.

It isolates workloads at the tenant or team level while delegating actual resource sharing and scheduling decisions to a higher-level shared queue (often a ClusterQueue).

In practice, a LocalQueue groups “who submitted the work.”

## Why it matters in GPUaaS
Multi-tenant GPU platforms need isolation and fairness:

- each tenant should have separate limits
- workloads should not interfere directly with others
- usage should be tracked per tenant
- policy should be enforceable at the boundary

LocalQueues provide this isolation while still allowing the platform to share the global GPU fleet efficiently.

Without LocalQueues:
- quotas are harder to enforce cleanly
- fairness becomes global and noisy
- accounting and chargeback are messy

## Responsibilities
- receive workload submissions from a tenant or namespace
- enforce local policies (quota, limits, priority defaults)
- track usage and consumption
- forward workloads to a shared queue for cluster-wide admission
- provide isolation boundaries between tenants

## Typical behavior
When a workload is created:
1. it is associated with a LocalQueue
2. local checks (quota/limits) are applied
3. the workload is then considered by the ClusterQueue for admission
4. once admitted, it can be scheduled

This creates a two-level model: local isolation + global fairness.

## Example
Tenant A and Tenant B each have their own LocalQueue.

- Tenant A submits 5 jobs
- Tenant B submits 5 jobs

Each queue enforces its own quota, while the ClusterQueue ensures fair sharing of the overall GPU fleet.

## Mental model
LocalQueue = “my team’s waiting line”

It separates tenants while still participating in shared cluster scheduling.

## Related terms
- [Queue](./queue.md)
- [ClusterQueue](./clusterqueue.md)
- [Admission Control](./admission-control.md)
- [Quota](./quota.md)
- [Fairness](./fairness.md)

