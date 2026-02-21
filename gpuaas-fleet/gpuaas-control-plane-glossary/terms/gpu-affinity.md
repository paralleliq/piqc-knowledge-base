# GPU Affinity

## Definition
GPU affinity is the set of placement rules that influence where workloads are scheduled based on GPU characteristics, node properties, or hardware topology.

It ensures that workloads run on compatible or optimal GPUs rather than any available device.

In GPUaaS platforms, affinity controls *which hardware a workload is allowed or preferred to run on*.

## Why it matters in GPUaaS
Not all GPUs are interchangeable. Workloads often require:

- specific GPU models (H100 vs T4)
- minimum VRAM
- local NVLink connections
- same-node placement
- isolation from other tenants
- region or zone locality

Without affinity:
- jobs may land on the wrong hardware
- performance degrades
- OOM errors occur
- distributed jobs fragment
- SLAs are missed

Affinity ensures correct placement and predictable behavior.

## Responsibilities
GPU affinity helps the platform:

- match workloads to correct GPU shapes
- enforce hardware compatibility
- improve performance
- reduce fragmentation
- maintain isolation
- optimize cost (cheap GPUs for inference, premium for training)

It guides scheduling decisions.

## Typical mechanisms
Affinity is often implemented using:

- node labels
- node selectors
- node affinity/anti-affinity
- taints and tolerations
- topology constraints

These inform the scheduler where pods can or should run.

## Typical behavior
When a workload is submitted:

1. scheduler evaluates resource request (e.g., 4 GPUs)
2. checks affinity constraints (e.g., H100 only)
3. filters eligible nodes
4. places pod on matching node

If no matching node exists, the workload waits or triggers provisioning.

## Example
Two GPU pools:

- H100 (training)
- T4 (inference)

Training job sets affinity:
- require H100

Scheduler:
- avoids T4 nodes
- only places on H100 pool

This guarantees expected performance.

## Affinity vs anti-affinity
- **Affinity** → prefer or require certain nodes
- **Anti-affinity** → avoid certain nodes

Example:
- avoid co-locating two heavy training jobs on same node

Both help optimize placement.

## Mental model
GPU affinity is the “placement rulebook” that tells the scheduler which machines are suitable for each workload.

## Related terms
- [GPU Shape](./gpu-shape.md)
- [Placement Constraints](./placement-constraints.md)
- [NodePool](./nodepool.md)
- [Provisioning](./provisioning.md)
- [Fragmentation](./fragmentation.md)
