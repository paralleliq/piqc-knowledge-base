# Device Plugin

## Definition
A device plugin is a Kubernetes component that advertises specialized hardware (such as GPUs, TPUs, or FPGAs) to the scheduler and enables pods to request and use those devices.

It acts as the bridge between the physical hardware and Kubernetes.

Without a device plugin, Kubernetes cannot see or allocate GPUs.

## Why it matters in GPUaaS
GPUs are not native Kubernetes resources like CPU or memory.

For the scheduler to:
- detect GPUs
- track availability
- allocate them to pods
- enforce limits

the hardware must be exposed through a device plugin.

In GPUaaS platforms, device plugins are foundational — they make GPUs schedulable resources.

## Responsibilities
A device plugin typically:

- discovers hardware devices on a node
- registers them with Kubernetes
- reports health status
- exposes devices as resources (e.g., `nvidia.com/gpu`)
- allocates devices to pods when requested
- handles cleanup when pods terminate

It enables safe and exclusive device assignment.

## Typical behavior
1. plugin runs as a DaemonSet on each node
2. detects available GPUs
3. registers them with the kubelet
4. scheduler sees GPU capacity
5. pods request GPUs via resource limits
6. plugin assigns specific devices

This allows Kubernetes-native scheduling of GPUs.

## Example
Node has 8 GPUs.

Device plugin registers:
- `nvidia.com/gpu: 8`

A pod requests:
- `nvidia.com/gpu: 2`

Scheduler places the pod and the plugin assigns two GPUs.

Without the plugin, this request would fail.

## GPU-specific behavior
Common GPU plugins also:

- configure drivers and runtimes
- manage MIG partitions
- expose memory metrics
- report device health
- integrate with container runtimes

These capabilities enable more advanced scheduling and observability.

## Failure impact
If the device plugin fails:
- GPUs appear unavailable
- pods cannot schedule
- jobs remain pending

So plugin health is critical for cluster reliability.

## Mental model
The device plugin is the “translator” that tells Kubernetes:
“These physical GPUs exist, and here’s how to use them.”

## Related terms
- [Execution Layer](./execution-layer.md)
- [Provisioning](./provisioning.md)
- [GPU Utilization](./gpu-utilization.md)
- [Node](./nodeclaim.md)
- [Metrics](./metrics.md)
