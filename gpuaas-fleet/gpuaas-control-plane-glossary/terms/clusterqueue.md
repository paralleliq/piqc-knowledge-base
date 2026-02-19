# ClusterQueue

## Definition
A ClusterQueue is a shared, cluster-wide queue that aggregates workloads from multiple LocalQueues and manages how global resources are allocated across tenants.

It is responsible for enforcing fairness, quotas, and priority at the fleet level.

While a LocalQueue represents “who submitted the work,” a ClusterQueue represents “how the shared cluster capacity is divided.”

## Why it matters in GPUaaS
GPU clusters are multi-tenant and capacity is limited. Multiple teams may request large jobs simultaneously, and the platform must decide:

- who runs first
- how much each tenant can use
- when to preempt or reclaim
- how to prevent starvation

ClusterQueues provide a central mechanism to enforce these policies across the entire fleet.

Without a ClusterQueue:
- tenants can crowd each other out
- fairness is difficult to guarantee
- global utilization becomes unpredictable
- higher-tier workloads may miss SLAs

## Responsibilities
- aggregate workloads from many LocalQueues
- enforce global quotas and resource limits
- prioritize higher-tier or urgent jobs
- determine admission order
- coordinate preemption and reclaim
- ensure fair sharing of the fleet

## Typical behavior
When workloads arrive:
1. they enter their LocalQueue
2. the LocalQueue forwards them to the ClusterQueue
3. the ClusterQueue evaluates global capacity and policy
4. workloads are admitted in priority/fair order
5. admitted workloads proceed to scheduling

This creates a two-level structure:
local isolation + global fairness.

## Example
The fleet has 16 GPUs.

- Tenant A requests 12 GPUs
- Tenant B requests 12 GPUs

The ClusterQueue may:
- split capacity fairly (8 + 8), or
- prioritize a higher tier tenant

Rather than allowing one tenant to monopolize the fleet.

## Mental model
ClusterQueue = “the shared traffic controller for the whole cluster”

It decides how limited GPU capacity is distributed among all tenants.

## Related terms
- [Queue](./queue.md)
- [LocalQueue](./localqueue.md)
- [Admission Control](./admission-control.md)
- [Priority Class](./priority-class.md)
- [Fairness](./fairness.md)
- [Quota](./quota.md)

