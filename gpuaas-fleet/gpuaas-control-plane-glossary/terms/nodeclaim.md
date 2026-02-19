# NodeClaim

## Definition
A NodeClaim is a request to provision a specific node that satisfies the requirements of pending workloads.

It represents a single unit of capacity being created — typically one VM or physical machine — and is fulfilled by the autoscaler.

If a NodePool defines *how nodes should look*, a NodeClaim is the concrete request to create one.

## Why it matters in GPUaaS
GPU workloads often require precise capacity:
- specific GPU models (H100, A100, etc.)
- exact counts
- particular zones or topology
- large, synchronized groups for training

NodeClaims allow the platform to request nodes that exactly match those needs instead of scaling blindly.

This enables:
- correct hardware selection
- predictable provisioning
- gang provisioning for distributed jobs
- reduced fragmentation

## Responsibilities
- describe the node’s required characteristics
- trigger provisioning of a new machine
- track lifecycle from requested → launching → ready → deleted
- bind workloads once the node becomes available

NodeClaims are typically created automatically by the autoscaler in response to demand.

## Typical behavior
1. pods are unschedulable
2. autoscaler determines required capacity
3. creates one or more NodeClaims
4. infrastructure provisions matching nodes
5. nodes join the cluster
6. workloads schedule onto them

Each NodeClaim corresponds to one node.

## Example
A training job requires 8 GPUs.

The system:
- calculates 8 nodes needed
- creates 8 NodeClaims
- waits for all nodes to become Ready
- then admits the workload

This supports gang-style provisioning.

## Mental model
NodeClaim is the “order ticket” for one new machine.

It is the concrete, per-node action that turns capacity planning into real hardware.

## Related terms
- [NodePool](./nodepool.md)
- [Karpenter](./karpenter.md)
- [Provisioning](./provisioning.md)
- [Gang Provisioning](./gang-provisioning.md)
- [Reactive Scaling](./reactive-scaling.md)

