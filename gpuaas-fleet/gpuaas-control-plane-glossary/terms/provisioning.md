# Provisioning

## Definition
Provisioning is the process of creating and preparing compute capacity so workloads can run.

In GPUaaS platforms, this typically means allocating and bringing up GPU nodes (VMs, bare metal, or instances) and making them ready for scheduling.

It answers:
“Do we have the machines needed to run this workload?”

## Why it matters in GPUaaS
GPU provisioning is slower and more expensive than CPU provisioning. Nodes can take tens of seconds or minutes to become ready.

Without careful provisioning:
- jobs experience long cold starts
- distributed training partially starts
- idle GPUs appear
- capacity is wasted
- SLAs are missed

Coordinating provisioning with admission is critical for predictable startup and high utilization.

## Responsibilities
- create new nodes when demand increases
- select appropriate instance types (GPU model, memory, region)
- enforce pool or tier constraints
- prepare nodes until Ready for scheduling
- remove or consolidate nodes when idle

## Typical behavior
When demand exceeds capacity:
1. the autoscaler detects unschedulable workloads
2. new nodes are requested
3. nodes are created and bootstrapped
4. nodes join the cluster
5. workloads are scheduled

Provisioning can be reactive or proactive.

## Reactive vs proactive
- **Reactive provisioning:** add nodes only after workloads are pending
- **Proactive provisioning:** create capacity ahead of admission

Reactive is simpler but causes delays and partial starts. Proactive reduces latency and improves reliability for large jobs.

## Example
A training job needs 8 GPUs but only 4 are available.

Provisioning:
- create 4 additional GPU nodes
- wait until they are Ready
- then admit the job

This ensures the workload starts cleanly.

## Mental model
Provisioning is the supply side of the system: it provides the hardware capacity that scheduling consumes.

## Related terms
- [Autoscaler](./autoscaler.md)
- [Reactive Scaling](./reactive-scaling.md)
- [Proactive Scaling](./proactive-scaling.md)
- [NodePool](./nodepool.md)
- [NodeClaim](./nodeclaim.md)
- [Gang Provisioning](./gang-provisioning.md)

