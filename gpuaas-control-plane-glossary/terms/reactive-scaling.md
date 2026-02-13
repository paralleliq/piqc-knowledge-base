# Reactive Scaling

## Definition
Reactive scaling is a provisioning strategy where new capacity is added only after workloads become unschedulable or pending.

The system reacts to demand signals rather than preparing capacity in advance.

In this model:
demand → pending workloads → scale up

## Why it matters in GPUaaS
Reactive scaling works reasonably well for stateless or small workloads, but it introduces significant delays and inefficiencies for GPU platforms where:

- provisioning is slow (tens of seconds to minutes)
- distributed jobs require many GPUs at once
- startup synchronization is critical

These delays directly impact utilization, cost, and reliability.

## Responsibilities
- detect pending or unschedulable workloads
- request additional nodes
- provision nodes
- allow scheduling once nodes are ready

Reactive scaling is typically handled automatically by an autoscaler.

## Typical behavior
1. workload is admitted
2. scheduler cannot place pods (no capacity)
3. pods remain pending
4. autoscaler notices demand
5. nodes are provisioned
6. nodes gradually become ready
7. pods start as capacity appears

This creates a lag between admission and execution.

## Common problems
Reactive scaling often causes:
- cold starts
- staggered pod startup
- idle GPUs
- partial runs for distributed training
- unpredictable latency

These issues are especially costly for large GPU jobs.

## Example
A training job requests 8 GPUs, but none are available.

With reactive scaling:
- job is admitted immediately
- pods wait pending
- nodes are provisioned one by one
- some workers start early and idle

This leads to wasted GPU time and potential timeouts.

## When it works well
Reactive scaling is usually sufficient for:
- inference services
- stateless workloads
- small or single-GPU jobs

Where synchronized startup is not required.

## Mental model
Reactive scaling follows demand after it happens.

It is simple but slower and less predictable for large GPU workloads.

## Related terms
- [Provisioning](./provisioning.md)
- [Proactive Scaling](./proactive-scaling.md)
- [Autoscaler](./autoscaler.md)
- [Cold Start](./cold-start.md)
- [Gang Scheduling](./gang-scheduling.md)

