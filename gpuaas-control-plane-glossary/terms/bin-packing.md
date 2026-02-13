# Bin Packing

## Definition
Bin packing is a scheduling strategy that places workloads onto the fewest possible nodes in order to maximize utilization and minimize wasted capacity.

It attempts to tightly “pack” workloads together rather than spreading them evenly across the fleet.

In GPUaaS, bin packing concentrates jobs onto fewer GPU nodes so other nodes remain completely free or can be removed.

## Why it matters in GPUaaS
GPU nodes are expensive. Spreading workloads thinly across many nodes leads to:

- low utilization
- stranded GPUs
- fragmentation
- unnecessary provisioning
- higher costs

Bin packing improves efficiency by:
- filling nodes first
- freeing entire nodes
- enabling consolidation and scale-down
- preserving large contiguous capacity for big jobs

This increases effective fleet utilization.

## Responsibilities
- prefer already-active nodes when placing pods
- minimize partially used nodes
- group similar workloads together
- reduce fragmentation
- create empty nodes that can be terminated

It is often implemented via scheduler policies or autoscaler consolidation logic.

## Typical behavior
Instead of:
- 4 nodes with 1 GPU used each

Bin packing aims for:
- 1 node with 4 GPUs used
- 3 nodes empty (can be removed)

Same work, fewer machines.

## Example
Cluster has 8 nodes with 8 GPUs each.

Workload needs 16 GPUs total.

Without bin packing:
- spread across 8 nodes (2 each)

With bin packing:
- pack into 2 nodes (8 each)
- 6 nodes remain free for scale-down

This reduces cost and preserves large contiguous blocks.

## Trade-offs
Bin packing improves utilization but may:
- reduce fault isolation
- create hotspots
- increase rescheduling churn if too aggressive

Platforms often balance bin packing with stability and availability.

## Mental model
Bin packing fills one “box” completely before opening the next, keeping capacity dense and efficient.

## Related terms
- [Fragmentation](./fragmentation.md)
- [Consolidation](./consolidation.md)
- [Provisioning](./provisioning.md)
- [Scale Down](./scale-down.md)
- [GPU Utilization](./gpu-utilization.md)

