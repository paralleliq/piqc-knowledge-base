# Consolidation

## Definition
Consolidation is the process of reducing wasted capacity by packing workloads onto fewer nodes and removing or downsizing underutilized ones.

It improves efficiency by eliminating fragmentation and shutting down idle or lightly loaded machines.

In simple terms: use fewer nodes to do the same work.

## Why it matters in GPUaaS
GPU nodes are expensive. Even small inefficiencies add up quickly.

Common problems include:
- nodes with only 1 GPU used out of 8
- scattered single-GPU workloads
- idle nodes left running after jobs finish
- over-provisioned pools

Without consolidation:
- utilization drops
- costs rise
- fragmentation prevents larger jobs from scheduling
- the fleet grows unnecessarily

Consolidation directly improves $/GPU-hour efficiency.

## Responsibilities
- detect underutilized nodes
- reschedule or pack workloads onto fewer nodes
- drain or terminate empty nodes
- reduce fragmentation
- maintain required capacity levels

Consolidation is typically handled automatically by the autoscaler.

## Typical behavior
1. system observes low utilization on several nodes
2. workloads are safely moved or rescheduled
3. nodes become empty
4. nodes are drained and terminated

The result is fewer, fuller nodes.

## Example
Cluster has:
- 4 nodes with 1 GPU used each

Instead of 4 partially used nodes:
- move workloads to 1 node
- terminate the other 3

This saves 3 nodes’ worth of cost.

## Trade-offs
Consolidation improves efficiency but may:
- cause brief rescheduling disruptions
- increase churn if too aggressive
- require coordination with disruption budgets

Platforms often balance consolidation with stability.

## Mental model
Consolidation is the “cleanup pass” that removes waste and packs work tightly to maximize utilization.

## Related terms
- [Provisioning](./provisioning.md)
- [Bin Packing](./bin-packing.md)
- [Fragmentation](./fragmentation.md)
- [Drain](./drain.md)
- [Scale Down](./scale-down.md)
- [Karpenter](./karpenter.md)

