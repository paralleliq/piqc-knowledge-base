# GPU Shape

## Definition
A GPU shape is the specific configuration and characteristics of a GPU resource or node, including the GPU model, memory size, count, interconnect, and hardware topology.

It describes the “form factor” of capacity that a workload requires.

In GPUaaS, shape determines both performance and placement compatibility.

## Why it matters in GPUaaS
Different workloads have different hardware needs:

- training → large memory, fast interconnects
- inference → smaller, cheaper GPUs
- distributed jobs → specific topology (NVLink, same host)

If the wrong shape is used:
- jobs may fail (OOM)
- performance degrades
- costs increase unnecessarily
- placement becomes inefficient

Selecting the correct GPU shape is critical for both efficiency and reliability.

## What defines a shape
Common attributes include:
- GPU model (H100, A100, T4, etc.)
- number of GPUs per node
- VRAM per GPU
- CPU/RAM on the host
- interconnect (NVLink, PCIe)
- network bandwidth
- region/zone

Together these determine how suitable the node is for a workload.

## Typical behavior
When a workload is submitted:
1. it specifies requirements (e.g., 8× H100 with NVLink)
2. scheduler or autoscaler selects matching capacity
3. nodes of the correct shape are provisioned
4. workload runs on compatible hardware

If no matching shape exists, admission is delayed or rejected.

## Example
Two shapes:

- T4 × 1 → low-cost inference
- H100 × 8 with NVLink → large training

Running a multi-GPU training job on T4 nodes:
- slower
- fragmented
- potentially impossible

Correct shape selection avoids this.

## Common usage patterns
Platforms often create separate pools by shape:
- premium training pool (H100)
- standard training pool (A100)
- inference pool (T4/L4)
- spot pool

This simplifies policy and placement.

## Mental model
GPU shape is the “size and type” of the machine you are renting — not all GPUs are interchangeable.

## Related terms
- [NodePool](./nodepool.md)
- [Provisioning](./provisioning.md)
- [Placement Constraints](./placement-constraints.md)
- [GPU Utilization](./gpu-utilization.md)
- [Fragmentation](./fragmentation.md)

