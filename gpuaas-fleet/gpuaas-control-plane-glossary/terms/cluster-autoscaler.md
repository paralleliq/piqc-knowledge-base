# Cluster Autoscaler

## Definition
Cluster Autoscaler is a Kubernetes component that automatically adjusts the number of nodes in a cluster based on pending workloads and overall utilization.

It adds nodes when pods cannot be scheduled and removes nodes when they are underutilized.

It is one of the earliest and most widely used node autoscaling solutions in Kubernetes.

## Why it matters in GPUaaS
GPU workloads frequently exceed available capacity:

- training jobs request many GPUs at once
- inference traffic spikes
- tenants compete for limited hardware

Without autoscaling:
- jobs remain pending
- queues grow
- GPUs sit idle during low demand
- costs increase during over-provisioning

Cluster Autoscaler helps match supply to demand automatically, improving both utilization and cost efficiency.

## Responsibilities
Cluster Autoscaler typically:

- detect unschedulable pods
- request new nodes from the cloud provider
- scale node groups up or down
- remove idle nodes safely
- respect disruption budgets
- maintain minimum/maximum node limits

It manages node count, not workload policy.

## Typical behavior
1. scheduler cannot place pods (insufficient resources)
2. pods remain pending
3. Cluster Autoscaler detects demand
4. increases node group size
5. nodes join cluster
6. pods schedule
7. later, idle nodes are removed

This loop runs continuously.

## Key characteristics
- works with predefined node groups
- scales entire groups uniformly
- simpler configuration
- reactive by design
- widely supported across cloud providers

It focuses on capacity availability rather than optimal instance selection.

## Example
A job requires 8 GPUs, but only 4 are available.

Cluster Autoscaler:
- increases GPU node group size by 4
- nodes provision
- job schedules

After completion:
- unused nodes scale down

## Limitations
Compared to newer autoscalers:

- reactive only (provisions after pods are pending)
- limited instance flexibility
- scales groups, not individual nodes
- less efficient for heterogeneous GPU fleets

These limitations can cause slower startup and higher costs in complex GPU environments.

## Cluster Autoscaler vs other autoscalers
- **Cluster Autoscaler** → group-based, simpler, reactive
- **Karpenter** → more dynamic, instance-aware, flexible provisioning

Many modern GPU platforms prefer more adaptive autoscalers for efficiency.

## Mental model
Cluster Autoscaler is the “basic fleet manager” that grows or shrinks node groups when the cluster runs out of space.

It ensures capacity exists but does not optimize how.

## Related terms
- [Autoscaler](./autoscaler.md)
- [Provisioning](./provisioning.md)
- [Reactive Scaling](./reactive-scaling.md)
- [Karpenter](./karpenter.md)
- [NodePool](./nodepool.md)
- [Utilization](./utilization.md)
