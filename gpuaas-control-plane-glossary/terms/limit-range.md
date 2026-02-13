# LimitRange

## Definition
LimitRange is a Kubernetes resource that defines minimum and maximum resource constraints for containers and pods within a namespace.

It enforces default, minimum, and maximum values for requests and limits such as CPU, memory, and GPUs.

In GPUaaS platforms, LimitRange helps prevent misconfigured or overly large workloads from monopolizing resources.

It answers:
“What is the allowed size of a single workload?”

## Why it matters in GPUaaS
GPU resources are scarce and expensive. Without safeguards, a tenant could accidentally or intentionally:

- request too many GPUs
- request zero limits
- over-allocate memory
- create oversized pods
- destabilize scheduling

This leads to:
- starvation for other tenants
- fragmentation
- scheduling failures
- unfair usage

LimitRange provides guardrails at the namespace level.

## Responsibilities
LimitRange typically:

- set default requests/limits
- enforce minimum sizes
- cap maximum sizes
- prevent pathological workloads
- standardize resource behavior
- protect cluster stability

It ensures workloads stay within acceptable bounds.

## Typical behavior
When a pod is created:

1. scheduler checks resource requests
2. LimitRange validates constraints
3. if missing → defaults applied
4. if too large/small → request rejected

This happens automatically at admission time.

## Example
Namespace policy:

- default GPU request: 1
- max GPUs per pod: 4

If user:
- omits GPU request → defaults to 1
- requests 8 GPUs → rejected

This prevents oversized jobs that could block the cluster.

## LimitRange vs ResourceQuota
These are related but different:

- **LimitRange** → per-pod/container limits
- **ResourceQuota** → total usage per namespace

Example:
- LimitRange: max 4 GPUs per pod
- ResourceQuota: max 20 GPUs total

Together they control both individual size and aggregate usage.

## Role in GPUaaS control plane
LimitRange often acts as:

- safety enforcement
- tenant guardrails
- admission validation

Higher-level control planes may set these automatically during tenant onboarding.

## Mental model
LimitRange is the “size limiter” that prevents any single workload from being too big or too small.

## Related terms
- [Resource Quota](./resource-quota.md)
- [Quota](./quota.md)
- [Admission Control](./admission-control.md)
- [Tenant Onboarding](./tenant-onboarding.md)
- [Fairness](./fairness.md)
