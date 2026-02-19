# NodePool

## Definition
A NodePool is a logical group of nodes that share the same provisioning rules, constraints, and configuration.

It defines how and where new nodes should be created, including instance types, GPU models, regions, limits, and scaling behavior.

In GPUaaS platforms, a NodePool represents a class of capacity, such as “H100 production” or “T4 best-effort.”

## Why it matters in GPUaaS
GPU fleets are rarely homogeneous. Different workloads require different hardware and policies:

- training vs inference
- premium vs best-effort tiers
- different GPU models (H100, A100, T4)
- separate regions or zones
- isolated pools for security or compliance

NodePools allow the platform to segment capacity and control how each segment behaves.

Without NodePools:
- placement is unpredictable
- policies are harder to enforce
- isolation is weaker
- scaling becomes coarse and inefficient

## Responsibilities
- define allowed instance types and GPU shapes
- set capacity limits and scaling bounds
- apply labels, taints, or constraints
- determine where nodes are launched (zones/regions)
- control consolidation and lifecycle behavior

NodePools guide the autoscaler when creating new nodes.

## Typical behavior
When a workload cannot be scheduled:
1. the autoscaler selects an appropriate NodePool
2. a NodeClaim is created from that pool
3. a node matching the pool’s constraints is provisioned
4. the workload is scheduled onto that node

## Common use cases
Examples of NodePools:
- H100-prod (high priority, reserved capacity)
- A100-standard (shared training pool)
- T4-best-effort (cheap, preemptible)
- spot-only pool
- inference-only pool

Each pool can have different policies and limits.

## Example
A tenant submits a training job requiring H100 GPUs.

The system:
- selects the H100 NodePool
- provisions nodes only from that pool
- prevents placement on lower-tier hardware

This ensures correct performance and isolation.

## Mental model
NodePool is a template or blueprint that defines what kind of machines the platform can create for a given class of workloads.

## Related terms
- [Karpenter](./karpenter.md)
- [NodeClaim](./nodeclaim.md)
- [Provisioning](./provisioning.md)
- [GPU Shape](./gpu-shape.md)
- [Taints and Affinity](./placement-constraints.md)

