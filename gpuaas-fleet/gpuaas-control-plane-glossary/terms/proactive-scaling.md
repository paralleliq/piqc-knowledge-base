# Proactive Scaling

## Definition
Proactive scaling is a provisioning strategy where capacity is created or reserved before workloads start, so resources are ready at admission time.

Instead of reacting to pending workloads, the system anticipates demand and prepares nodes in advance.

In this model:
provision first → then admit

## Why it matters in GPUaaS
GPU provisioning is slow and expensive. Waiting until workloads are pending can cause:

- long cold starts
- partial starts for distributed training
- idle ranks
- missed SLAs
- poor utilization

Proactive scaling reduces these issues by ensuring capacity is ready before execution begins.

This is especially important for large, multi-GPU training jobs that require synchronized startup.

## Responsibilities
- forecast or detect upcoming demand
- provision nodes ahead of time
- maintain warm or reserved capacity
- coordinate with admission control
- reduce startup latency and fragmentation

## Typical behavior
1. a workload request is received
2. the system calculates required capacity
3. nodes are provisioned first
4. once all nodes are ready, the workload is admitted
5. pods start immediately

This produces faster and more predictable startup.

## Common approaches
- gang provisioning for distributed jobs
- warm pools of pre-created nodes
- capacity buffers per tier
- scheduled or time-based scaling
- demand forecasting

## Example
A training job requires 8 GPUs.

With proactive scaling:
- 8 nodes are provisioned
- readiness is confirmed
- the job is admitted
- all workers start simultaneously

This avoids idle GPUs and timeouts.

## Trade-offs
Proactive scaling may:
- temporarily hold unused capacity
- increase short-term cost

But it often improves overall efficiency and reliability for GPU workloads.

## Mental model
Proactive scaling prepares supply before demand arrives, trading a small buffer of capacity for faster and more predictable execution.

## Related terms
- [Provisioning](./provisioning.md)
- [Reactive Scaling](./reactive-scaling.md)
- [Gang Provisioning](./gang-provisioning.md)
- [Warm Pool](./warm-pool.md)
- [Admission Gating](./admission-gating.md)

