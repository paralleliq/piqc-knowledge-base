# Cold Start

## Definition
A cold start is the delay experienced by a workload while waiting for infrastructure or runtime components to become ready before execution can begin.

In GPUaaS platforms, this usually happens when new nodes must be provisioned and initialized before pods can run.

Cold start time = request → first useful work

## Why it matters in GPUaaS
GPU provisioning is slower than typical CPU workloads because it involves:

- instance creation
- OS boot
- driver installation
- container runtime setup
- device plugin registration
- cluster join

This can take tens of seconds to several minutes.

For:
- interactive workloads
- inference APIs
- SLA-bound jobs
- distributed training

these delays directly hurt user experience and utilization.

## Where it occurs
Cold starts commonly happen when:

- autoscaler provisions new nodes reactively
- no warm capacity exists
- large training jobs need many GPUs at once
- nodes were recently scaled down
- containers/images are not cached

Any time the system must “prepare from zero,” startup is slow.

## Typical behavior
Reactive flow:
1. workload is admitted
2. no capacity exists
3. nodes are provisioned
4. nodes boot and join
5. pods schedule
6. workload finally starts

The entire wait time is the cold start.

## Example
A user submits a training job requiring 8 GPUs.

Provisioning takes 2 minutes.

The job waits idle for 2 minutes before any computation begins.

That delay is the cold start.

## Consequences
- slower job startup
- idle ranks during distributed training
- lower utilization
- poor user experience
- missed SLAs
- wasted GPU time

Cold starts are especially expensive for short or bursty workloads.

## How to reduce
- warm pools
- proactive scaling
- gang provisioning
- image pre-pulling
- capacity buffers

These approaches prepare resources ahead of time.

## Mental model
A cold start is the “boot-up tax” paid when the system must create capacity from scratch before work can begin.

## Related terms
- [Warm Pool](./warm-pool.md)
- [Provisioning](./provisioning.md)
- [Reactive Scaling](./reactive-scaling.md)
- [Proactive Scaling](./proactive-scaling.md)
- [Idle Rank](./idle-rank.md)

