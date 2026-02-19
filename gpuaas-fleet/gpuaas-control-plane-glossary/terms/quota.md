# Quota

## Definition
A quota is a limit that caps how much of a resource a tenant, team, or namespace is allowed to consume.

It sets an upper bound on usage to prevent any single user or workload from exhausting shared capacity.

In GPUaaS, quotas typically apply to GPUs, nodes, or total compute.

## Why it matters in GPUaaS
GPU resources are scarce and expensive. Without quotas:

- one tenant can monopolize the fleet
- other tenants may starve
- costs can spike unpredictably
- fairness becomes difficult to enforce

Quotas provide predictable boundaries and protect the platform from overconsumption.

## Responsibilities
- limit maximum GPU usage per tenant
- enforce contractual capacity tiers
- protect shared pools from runaway workloads
- provide guardrails even if other controls fail
- support accounting and chargeback

## Typical behavior
When a workload is submitted:
1. the system checks current usage
2. compares against the quota
3. if within limits → proceed
4. if exceeded → queue or reject

Quotas are usually enforced before admission.

## Example
Tenant A has a quota of 10 GPUs.

If Tenant A is already using 10 GPUs:
- new workloads are queued or denied
- no additional GPUs are allocated

This prevents the tenant from exceeding their allowed share.

## Types of quotas
Common forms include:
- hard limits (cannot exceed)
- soft limits (can burst temporarily)
- per-namespace limits
- per-tier limits
- per-resource-type limits

## Mental model
A quota is the “budget cap” for resource usage that keeps the cluster balanced and predictable.

## Related terms
- [Resource Quota](./resource-quota.md)
- [Fairness](./fairness.md)
- [Admission Control](./admission-control.md)
- [ClusterQueue](./clusterqueue.md)
- [Priority Class](./priority-class.md)

