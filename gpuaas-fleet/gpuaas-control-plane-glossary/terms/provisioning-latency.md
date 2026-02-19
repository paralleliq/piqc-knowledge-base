# Provisioning Latency

## Definition
Provisioning latency is the time it takes for new compute capacity (nodes, GPUs, or pods) to become ready for workloads after a scaling or provisioning request is made.

It measures how long the system waits between:
“we need more capacity” → “capacity is usable”

In GPUaaS platforms, provisioning latency directly impacts startup time and user experience.

## Why it matters in GPUaaS
GPU infrastructure is slow to provision compared to CPU:

- cloud instance startup time
- GPU driver initialization
- container runtime setup
- device plugin registration
- node joining the cluster
- image pulls

This can take:
- tens of seconds
- or several minutes

During this delay:
- jobs stay pending
- queues grow
- SLAs are missed
- training workers idle
- users perceive the system as slow

Provisioning latency is often the hidden bottleneck in GPU platforms.

## Responsibilities
Understanding provisioning latency helps the platform:

- size capacity buffers
- decide warm pool sizes
- choose proactive vs reactive scaling
- implement admission gating
- set realistic SLAs
- optimize startup paths
- improve user satisfaction

It directly informs control-plane strategy.

## Typical components of latency
Provisioning latency usually includes:

### Infrastructure
- VM or bare-metal boot
- network setup

### Node initialization
- OS startup
- drivers loaded
- container runtime ready

### Kubernetes
- node registration
- device plugin discovery
- health checks

### Workload
- image pulls
- container startup
- readiness probes

Total latency is the sum of all steps.

## Example
Training job requests 8 GPUs.

Provisioning time:
- VM boot: 60s
- drivers: 30s
- node join: 20s
- containers: 20s

Total ≈ 130s

Without mitigation:
- job waits over 2 minutes

With warm pool:
- near-zero startup time

## Common impacts
High provisioning latency leads to:

- long queue times
- idle ranks in distributed training
- cold starts for inference
- poor SLA adherence
- over-provisioning to compensate
- frustrated users

Reducing this latency significantly improves perceived performance.

## Mitigation strategies

### Capacity buffers
Keep spare GPUs ready

### Warm pools
Pre-provision idle nodes

### Proactive scaling
Scale before demand

### Image caching
Reduce container startup time

### Admission gating
Wait for full capacity before starting

### Faster autoscalers
Smarter provisioning decisions

Platforms often combine several techniques.

## Role in the control plane
The control plane may:

- monitor provisioning
