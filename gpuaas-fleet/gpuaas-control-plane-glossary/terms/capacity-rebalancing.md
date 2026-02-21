# Capacity Rebalancing

## Definition
Capacity rebalancing is the process of redistributing GPU resources across tenants, pools, or nodes to better match current demand, improve utilization, and maintain fairness or SLA guarantees.

It adjusts *where* capacity is allocated, not just *how much* exists.

In GPUaaS, rebalancing answers:
“Are our GPUs assigned to the right places right now?”

## Why it matters in GPUaaS
Demand constantly shifts:

- some tenants become idle
- others experience spikes
- certain GPU shapes are overused
- others sit empty
- fragmentation builds up over time

If capacity remains statically assigned:
- GPUs sit idle in one pool
- queues grow in another
- SLAs are missed
- costs increase

Rebalancing ensures supply follows demand.

## Responsibilities
Capacity rebalancing typically involves:

- moving capacity between tenants or pools
- reclaiming idle GPUs
- adjusting quotas or reservations
- resizing node pools
- consolidating fragmented nodes
- shifting workloads to better placements
- maintaining target utilization and fairness

It is often driven by periodic reconciliation or policy checks.

## Typical triggers
Common signals include:

- sustained queue depth in one pool
- low utilization in another
- SLA breaches
- idle nodes
- uneven fragmentation
- tier-based priority changes
- time-of-day demand shifts

These indicate misallocated capacity.

## Typical behavior
1. observe utilization and queue metrics
2. detect imbalance
3. identify reclaimable or movable capacity
4. adjust pools/quotas or migrate workloads
5. consolidate or provision as needed

The system converges toward better distribution.

## Example
Cluster:
- Pool A (training) → 90% utilization + growing queue
- Pool B (best-effort) → 30% utilization

Rebalancing:
- reclaim nodes from Pool B
- move them to Pool A
- reduce backlog
- improve overall utilization

Same total capacity, better allocation.

## Common techniques
- reclaim/preemption
- consolidation
- node pool resizing
- quota adjustments
- proactive scaling in busy pools
- scale-down in idle pools

These work together to maintain balance.

## Mental model
Capacity rebalancing is “traffic management” for GPUs — moving supply to where demand is highest.

## Related terms
- [Reclaim](./reclaim.md)
- [Consolidation](./consolidation.md)
- [Provisioning](./provisioning.md)
- [Utilization](./utilization.md)
- [Queue Depth](./queue-depth.md)
- [Reconciliation Loop](./reconciliation-loop.md)

