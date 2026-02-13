# Karpenter

## Definition
Karpenter is a Kubernetes-native autoscaler that dynamically provisions and removes nodes based on real-time workload demand.

It creates the right type and number of nodes when pods cannot be scheduled and consolidates or removes nodes when capacity is idle.

In GPUaaS platforms, Karpenter commonly manages the supply side of the fleet.

## Why it matters in GPUaaS
GPU workloads are highly variable:
- large training jobs arrive in bursts
- inference traffic fluctuates
- nodes are expensive and slow to provision

Static node pools either:
- waste money (too many idle GPUs), or
- cause delays (too few nodes)

Karpenter enables elastic GPU capacity by scaling the fleet up and down automatically, improving utilization and cost efficiency.

## Responsibilities
- detect unschedulable pods
- provision nodes that match workload requirements (GPU type, size, zone)
- select optimal instance types
- remove underutilized nodes
- consolidate fragmented capacity

It focuses on capacity supply, not workload admission or fairness.

## Typical behavior
1. a workload is admitted
2. scheduler cannot place pods
3. Karpenter observes pending pods
4. creates NodeClaims
5. nodes launch and join the cluster
6. pods schedule onto the new nodes
7. later, idle nodes may be consolidated or removed

## Key concepts
- **NodePool:** defines provisioning constraints and policies
- **NodeClaim:** an individual request for a new node
- **Consolidation:** removing or replacing underutilized nodes

These primitives allow precise control over fleet composition.

## Limitations
Karpenter does not:
- enforce quotas
- manage fairness
- gate admission
- understand tenant policies

It only provisions capacity after demand appears.

Higher-level control planes must coordinate when and why provisioning occurs.

## Example
A job requests 8 GPUs but only 2 are free.

Karpenter:
- provisions 6 new GPU nodes
- waits for readiness
- pods schedule onto those nodes

Without coordination, this is reactive and may cause delayed or staggered startup.

## Mental model
Karpenter is the cluster’s “capacity factory,” creating and removing machines as needed.

It handles supply, not policy.

## Related terms
- [Provisioning](./provisioning.md)
- [Reactive Scaling](./reactive-scaling.md)
- [Proactive Scaling](./proactive-scaling.md)
- [NodePool](./nodepool.md)
- [NodeClaim](./nodeclaim.md)
- [Cluster Autoscaler](./cluster-autoscaler.md)

