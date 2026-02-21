# Topology Aware Scheduling

## Definition
Topology-aware scheduling is the practice of placing workloads based on the physical and network layout of the cluster to optimize performance, latency, and communication efficiency.

It accounts for where hardware is located relative to each other — such as GPUs on the same node, rack, or availability zone.

In GPUaaS platforms, topology-aware scheduling answers:
“Where should this workload run for the best performance?”

## Why it matters in GPUaaS
GPU workloads — especially distributed training — are highly sensitive to topology:

- cross-node communication is slower
- cross-rack latency increases
- cross-zone traffic is expensive
- NVLink is faster than PCIe
- local GPUs outperform remote ones

If placement ignores topology:
- training slows down
- synchronization overhead increases
- idle ranks appear
- network bottlenecks occur
- costs rise

Topology-aware placement can significantly improve throughput and efficiency.

## Responsibilities
Topology-aware scheduling helps the platform:

- co-locate GPUs for distributed jobs
- reduce network hops
- minimize latency
- avoid cross-zone traffic
- leverage high-bandwidth interconnects (NVLink/InfiniBand)
- improve training time and stability

It optimizes placement beyond simple resource matching.

## Common topology levels

### GPU-level
- same GPU slice or MIG partition

### Node-level
- same physical machine

### Rack-level
- same rack or switch

### Zone-level
- same availability zone

### Region-level
- same geographic region

Closer placement generally means faster communication.

## Typical behavior
1. workload declares topology requirements
2. scheduler filters nodes based on labels
3. prefers tighter placement (same node/rack/zone)
4. schedules pods accordingly

If topology cannot be satisfied:
- job may wait
- or provisioning may occur

This prioritizes performance over immediate placement.

## Example
Distributed training job requires 8 GPUs.

Without topology awareness:
- GPUs spread across 4 nodes in 2 zones
- slow network → longer training time

With topology-aware scheduling:
- all 8 GPUs placed on 2 NVLink-connected nodes
- faster synchronization
- shorter training time

Performance improves significantly.

## Kubernetes mechanisms
Common tools include:

- node labels (zone, rack, gpu type)
- node affinity/anti-affinity
- topology spread constraints
- pod affinity
- taints/tolerations
- dedicated pools

These express placement intent to the scheduler.

## Training vs inference
### Training
Highly sensitive to topology  
Strong placement constraints recommended

### Inference
Less sensitive  
Often optimized for utilization instead

Topology policies often vary by workload type.

## Role in the control plane
The control plane may:

- assign topology constraints automatically
- map training jobs to tightly coupled pools
- avoid cross-zone costs
- balance performance vs utilization
- integrate with provisioning decisions

It encodes performance policy into placement rules.

## Mental model
Topology-aware scheduling is “place close what talks a lot.”

Keeping communicating workloads near each other reduces latency and improves performance.

## Related terms
- [Placement Constraints](./placement-constraints.md)
- [GPU Affinity](./gpu-affinity.md)
- [Provisioning](./provisioning.md)
- [Fragmentation](./fragmentation.md)
- [Gang Scheduling](./gang-scheduling.md)
- [Idle Rank](./idle-rank.md)
