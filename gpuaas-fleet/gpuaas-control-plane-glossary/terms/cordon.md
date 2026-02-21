# Cordon

## Definition
Cordon is the action of marking a Kubernetes node as unschedulable so that no new pods can be placed on it.

Existing workloads continue running, but the scheduler will not assign new workloads to that node.

In GPUaaS platforms, cordoning is often the first step before maintenance, consolidation, or scale-down operations.

It answers:
“How do we safely stop placing new work on this node?”

## Why it matters in GPUaaS
GPU workloads are:

- long-running (training jobs)
- latency-sensitive (inference)
- expensive to interrupt

Immediately terminating a node can:

- waste GPU hours
- kill distributed jobs
- violate SLAs
- create unnecessary retries

Cordoning allows the platform to freeze scheduling to a node while existing workloads either finish or are drained in a controlled way.

It is a safety mechanism.

## Responsibilities
Cordoning helps the platform:

- prepare nodes for upgrades
- isolate unhealthy nodes
- consolidate workloads
- safely scale down capacity
- handle spot interruption notices
- reduce scheduling onto problematic hardware

It prevents new workload placement without disruption.

## Typical behavior

When a node is cordoned:

1. node is marked unschedulable
2. scheduler ignores it for new pods
3. existing pods continue running
4. operator may later drain the node

Cordoning alone does not evict workloads.

## Example

Cluster has 8 GPUs on a node.

Control plane decides to scale down:

- cordon node
- wait for jobs to finish (or drain them)
- terminate node

This avoids placing new work that would immediately need eviction.

## Cordon vs Drain

- **Cordon** → stop new placements
- **Drain** → evict existing pods

Typical safe workflow:

cordon → drain → upgrade/terminate

Cordoning is a non-disruptive action; draining is disruptive.

## Common use cases

- rolling upgrades
- driver updates
- GPU replacement
- consolidation workflows
- spot interruption handling
- incident isolation

Cordoning is often triggered automatically by autoscalers or control-plane workflows.

## Role in the control plane

The control plane may:

- cordon underutilized nodes before consolidation
- cordon nodes receiving interruption notices
- cordon unhealthy hardware
- coordinate drain timing based on tier policies
- protect premium workloads during maintenance

It is part of safe actuation.

## Mental model

Cordon is the “closed sign” on a node — no new work enters, but current work can finish safely.

## Related terms

- [Drain](./drain.md)
- [Scale Down](./scale-down.md)
- [Consolidation](./consolidation.md)
- [Spot Interruption](./spot-interruption.md)
- [Provisioning](./provisioning.md)
