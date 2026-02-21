# Reservation

## Definition
A reservation is a guarantee that a specific amount of capacity (such as GPUs or nodes) is set aside for a tenant, workload, or tier and cannot be used by others.

It provides assured access to resources regardless of overall cluster demand.

In GPUaaS platforms, reservations answer:
“How much capacity is guaranteed to me?”

## Why it matters in GPUaaS
GPU clusters are shared environments with competing tenants.

Without reservations:

- premium customers may be starved
- important jobs may wait behind best-effort workloads
- SLAs cannot be guaranteed
- planning becomes unpredictable

Reservations provide predictability and reliability by protecting capacity for specific users or tiers.

They are essential for enterprise or production workloads.

## Responsibilities
Reservations typically:

- allocate dedicated capacity to a tenant or tier
- prevent other workloads from consuming that capacity
- ensure fast startup times
- protect SLAs/SLOs
- enable premium pricing models
- simplify capacity planning

They trade flexibility for guarantees.

## Typical behavior
When capacity is reserved:

1. a portion of GPUs is marked unavailable to others
2. only the owning tenant or tier can use them
3. other workloads cannot schedule onto that capacity
4. if unused, it may optionally be temporarily lent out

This ensures guaranteed access when needed.

## Example
Cluster:
- 100 GPUs total

Reservations:
- Tenant A → 20 GPUs
- Tenant B → 10 GPUs
- 70 GPUs shared

Even during peak demand:
- Tenant A always has access to 20 GPUs
- others cannot take them

This supports predictable performance.

## Types of reservations

### Hard reservation
Strictly dedicated capacity  
Never shared

### Soft reservation
Preferred but reclaimable  
Unused capacity may be temporarily borrowed

### Time-based
Reserved for specific windows (e.g., nightly training)

### Tier-based
Premium tier gets guaranteed pool

Platforms often mix these models.

## Reservation vs quota
- **Reservation** → guarantees minimum capacity
- **Quota** → limits maximum usage

Example:
- reservation: at least 10 GPUs
- quota: at most 30 GPUs

Together they define the usage range.

## Trade-offs
Reservations:
- improve predictability and SLA compliance
- reduce contention

But:
- may lower overall utilization
- can leave GPUs idle if unused

Many platforms allow temporary sharing to improve efficiency.

## Role in the control plane
The control plane may:

- create reserved pools
- enforce isolation
- adjust reservations dynamically
- reclaim unused capacity
- integrate with billing/chargeback
- map reservations to tiers

It manages the balance between guarantees and efficiency.

## Mental model
A reservation is a “seat with your name on it” — no one else can take it when you need it.

## Related terms
- [Quota](./quota.md)
- [Capacity Buffer](./capacity-buffer.md)
- [Admission Control](./admission-control.md)
- [Fairness](./fairness.md)
- [Tenant Onboarding](./tenant-onboarding.md)
- [Provisioning](./provisioning.md)
