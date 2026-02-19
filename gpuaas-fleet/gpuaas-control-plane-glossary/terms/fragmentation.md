# Fragmentation

## Definition
Fragmentation is the condition where free resources exist in the cluster but are scattered in small, unusable pieces that cannot satisfy larger workload requests.

Although total capacity may be sufficient, it is not available in the right shape or grouping.

In GPU clusters, fragmentation commonly means GPUs are spread across many partially used nodes instead of being concentrated.

## Why it matters in GPUaaS
Many GPU workloads require:
- multiple GPUs on the same node
- contiguous GPUs
- specific topology (NVLink, same host)
- large synchronized allocations

If GPUs are fragmented:
- large jobs cannot start
- nodes stay partially utilized
- utilization looks high but capacity is unusable
- unnecessary provisioning occurs
- costs increase

Fragmentation directly reduces effective capacity.

## Typical causes
- many small single-GPU jobs
- uneven scheduling
- reactive scaling
- lack of bin packing
- nodes not consolidated after workloads finish
- mixed hardware or placement constraints

Over time, these effects scatter free GPUs across the fleet.

## Example
Cluster has 8 nodes with 1 free GPU each.

Total free GPUs = 8

A training job needs 8 GPUs on one node (NVLink).

Even though capacity exists, the job cannot run.

This is fragmentation.

## Consequences
- failed or delayed admissions
- more node provisioning than necessary
- idle GPUs
- higher costs
- lower effective utilization

Fragmentation often hides behind misleading metrics like “70% utilized.”

## How to reduce
- bin packing strategies
- consolidation of lightly used nodes
- proactive placement policies
- draining and rescheduling
- separating pools by workload type
- larger, coordinated admissions

These keep free capacity grouped and usable.

## Mental model
Fragmentation is like having free seats scattered across many buses when you need one bus with all seats available.

Capacity exists, but not in the right form.

## Related terms
- [Bin Packing](./bin-packing.md)
- [Consolidation](./consolidation.md)
- [Provisioning](./provisioning.md)
- [Gang Scheduling](./gang-scheduling.md)
- [GPU Utilization](./gpu-utilization.md)

