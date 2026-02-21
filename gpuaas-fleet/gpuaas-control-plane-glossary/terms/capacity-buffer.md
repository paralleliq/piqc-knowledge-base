# Capacity Buffer

## Definition
A capacity buffer is a reserved portion of compute resources kept intentionally free so new or high-priority workloads can start immediately without waiting for provisioning.

It provides spare headroom between current utilization and total capacity.

In GPUaaS, a capacity buffer acts as shock absorption for sudden demand spikes.

## Why it matters in GPUaaS
GPU provisioning is slow and workloads often arrive unpredictably:

- training jobs request many GPUs at once
- inference traffic spikes
- SLA-bound workloads need fast startup

If the cluster runs at 100% utilization:
- every new workload waits
- cold starts increase
- queues grow
- SLAs are missed

A capacity buffer prevents this by ensuring some resources are always ready.

## Responsibilities
Capacity buffers help the platform:

- reduce startup latency
- absorb burst traffic
- protect SLA tiers
- avoid immediate reactive scaling
- smooth out provisioning delays
- reduce partial starts and idle ranks

They improve responsiveness at the cost of some idle capacity.

## Typical behavior
Instead of:
- 100 GPUs total
- 100 GPUs allocated

Platforms maintain:
- 100 GPUs total
- 85–90 allocated
- 10–15 kept free

When demand spikes:
- workloads use the buffer immediately
- autoscaler backfills capacity in the background

This decouples startup from provisioning time.

## Example
Cluster keeps 5 H100 GPUs as a buffer.

A production job requiring 4 GPUs arrives:
- starts instantly
- no waiting for provisioning

Autoscaler then provisions replacements to restore the buffer.

## Buffer vs warm pool
These concepts are related:

- **Capacity buffer** → logical reserved headroom
- **Warm pool** → physically pre-provisioned idle nodes

Warm pools are one way to implement a buffer.

## Trade-offs
Capacity buffers:
- improve latency and reliability
- reduce cold starts

But:
- increase short-term cost due to idle capacity

Platforms balance buffer size based on tier or SLA.

## Mental model
A capacity buffer is “breathing room” for the cluster — spare GPUs kept ready so the system can react instantly to new demand.

## Related terms
- [Warm Pool](./warm-pool.md)
- [Provisioning](./provisioning.md)
- [Proactive Scaling](./proactive-scaling.md)
- [Cold Start](./cold-start.md)
- [Utilization](./utilization.md)
