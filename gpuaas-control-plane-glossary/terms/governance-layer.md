# Governance Layer

## Definition
The governance layer is the policy and decision-making component of the control plane that determines who is allowed to use which resources, under what conditions, and with what priority.

It translates business rules, tenant contracts, and operational constraints into enforceable plans that the orchestration and execution layers carry out.

## Why it matters in GPUaaS
GPU infrastructure is scarce, expensive, and shared across many tenants. Without governance, clusters suffer from noisy neighbors, starvation, poor utilization, and unpredictable costs.

The governance layer ensures:
- fair sharing across tenants
- predictable performance for higher tiers
- controlled reclaim and preemption
- cost and utilization efficiency
- consistent enforcement of platform rules

## Responsibilities
- define quotas, limits, and tiers
- track fleet capacity and allocations
- evaluate requests against policy and current state
- decide whether to admit, delay, provision, reclaim, or deny
- generate actionable plans for the orchestration layer
- record decisions for auditing and traceability

## What it does not do
The governance layer does not directly schedule pods or provision nodes. Instead, it decides what should happen and delegates enforcement to lower layers.

## Example
A tenant requests 8 GPUs for training. The governance layer checks quota and capacity, decides to provision nodes first, then admits the workload once all resources are ready.

## Related terms
- [Control Plane](./control-plane.md)
- [Orchestration Layer](./orchestration-layer.md)
- [Execution Layer](./execution-layer.md)
- [Admission Control](./admission-control.md)
- [Quota](./quota.md)
- [Fairness](./fairness.md)

