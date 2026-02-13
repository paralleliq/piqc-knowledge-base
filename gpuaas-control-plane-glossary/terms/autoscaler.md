# Autoscaler

## Definition
An autoscaler is a system component that automatically adjusts compute capacity based on current or predicted workload demand.

It adds resources when demand increases and removes resources when they are no longer needed.

In GPUaaS platforms, the autoscaler manages the supply side of the fleet.

It answers:
“How many nodes should exist right now?”

## Why it matters in GPUaaS
GPU demand is highly variable:

- training jobs arrive in bursts
- inference traffic fluctuates
- some pools sit idle at times

Static capacity leads to either:
- over-provisioning (wasted money), or
- under-provisioning (queues and delays)

Autoscaling enables:
- elastic capacity
- better utilization
- lower cost
- faster startup

Without it, the platform cannot efficiently match supply to demand.

## Responsibilities
An autoscaler typically:

- detects unschedulable or pending workloads
- provisions new nodes
- selects appropriate instance types or GPU shapes
- removes or consolidates idle nodes
- maintains target utilization
- enforces scaling limits

It focuses on capacity, not policy or fairness.

## Typical behavior
1. workload cannot be scheduled (insufficient GPUs)
2. autoscaler detects pending pods
3. provisions nodes
4. nodes join the cluster
5. workloads schedule
6. later, idle nodes are removed

Scaling up and down happens continuously.

## Types of autoscaling

### Reactive
Scale after demand appears  
(e.g., pending pods trigger provisioning)

- simple
- slower startup
- may cause cold starts

### Proactive
Scale before demand  
(e.g., warm pools, forecasts)

- faster startup
- higher cost buffer
- better for training/SLA workloads

Many platforms combine both.

## Common implementations
Examples include:

- cluster autoscalers
- node autoscalers
- provisioning controllers
- GPU-specific autoscalers

These integrate with the scheduler and cloud provider APIs.

## Example
A job requests 8 GPUs but only 4 are free.

Autoscaler:
- provisions 4 more nodes
- waits until Ready
- job schedules

Later, when idle:
- extra nodes are removed

## What it does not do
Autoscalers typically do not:

- enforce quotas
- manage fairness
- decide which tenant runs first
- apply business policies

Those responsibilities belong to the control plane and admission systems.

## Mental model
The autoscaler is the “capacity engine” that grows or shrinks the fleet to match demand.

It controls supply, not decisions.

## Related terms
- [Provisioning](./provisioning.md)
- [Karpenter](./karpenter.md)
- [Cluster Autoscaler](./cluster-autoscaler.md)
- [Reactive Scaling](./reactive-scaling.md)
- [Proactive Scaling](./proactive-scaling.md)
- [Utilization](./utilization.md)
