# Resource Quota

## Definition
A Resource Quota is a Kubernetes mechanism that enforces hard limits on how many resources a namespace or tenant can consume.

It sets strict caps on quantities such as GPUs, CPU, memory, pods, or other objects, preventing workloads from exceeding allowed limits at the API level.

Unlike higher-level policies, a Resource Quota is enforced directly by the cluster.

## Why it matters in GPUaaS
Resource Quotas act as the final safety guardrail for multi-tenant GPU platforms.

Even if admission control or higher-level policies fail, quotas ensure:
- tenants cannot exceed their contracted capacity
- one user cannot monopolize GPUs
- runaway workloads cannot exhaust the fleet
- resource usage remains predictable

For GPUs specifically, quotas prevent accidental or malicious over-allocation.

## Responsibilities
- enforce hard limits on resource usage
- reject new workloads that exceed limits
- provide per-tenant isolation
- protect cluster stability
- support accounting and chargeback

## Typical behavior
When a workload is created:
1. Kubernetes checks the namespace’s Resource Quota
2. if the new request exceeds limits → request is rejected
3. if within limits → workload proceeds

This happens before scheduling.

## Example
Namespace has a GPU Resource Quota of 8.

If 8 GPUs are already allocated:
- a new pod requesting 1 GPU is rejected immediately

This prevents the namespace from using more than its allowed share.

## Quota vs Quota (conceptual)
- **Quota (policy concept)**: business or platform rule defined by the control plane
- **Resource Quota (Kubernetes primitive)**: enforcement mechanism inside the cluster

Platforms often use both:
policy defines limits → Resource Quota enforces them.

## Mental model
Resource Quota is the hard fence that enforces resource limits at the cluster boundary.

## Related terms
- [Quota](./quota.md)
- [Admission Control](./admission-control.md)
- [Fairness](./fairness.md)
- [Namespace](./localqueue.md)
- [ClusterQueue](./clusterqueue.md)

