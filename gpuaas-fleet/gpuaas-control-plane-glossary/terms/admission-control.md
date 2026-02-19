# Admission Control

## Definition
Admission control is the process of deciding **whether, when, and under what conditions a workload is allowed to start** in the cluster.

It acts as the gate between workload submission and execution, ensuring that jobs only run when sufficient capacity, policy, and fairness requirements are satisfied.

Instead of “start immediately and hope resources appear,” admission control answers:
“Should this workload run now, later, or not at all?”

## Why it matters in GPUaaS
GPU resources are:
- scarce
- expensive
- slow to provision
- shared across tenants

Starting workloads without coordination often causes:
- cold starts
- partial starts for distributed training
- idle GPUs
- starvation of higher-priority jobs
- broken SLAs

Admission control prevents these issues by gating execution until conditions are met.

## Responsibilities
- enforce quotas and limits
- apply priority and fairness rules
- queue workloads when capacity is insufficient
- delay jobs until resources are ready
- coordinate with provisioning systems
- optionally reject invalid or non-compliant requests

## Common policies
Examples include:
- max GPUs per tenant
- tier-based priority (prod > standard > best-effort)
- gang admission for distributed training
- preemption of lower-priority workloads
- capacity-first (provision → then admit)

## Typical behavior
When a workload is submitted:
1. check policy and quota
2. check available capacity
3. decide:
   - admit now
   - queue
   - provision first
   - reject

Only admitted workloads are allowed to schedule onto nodes.

## Example
A training job requests 8 GPUs.

Without admission control:
- job starts immediately
- nodes provision slowly
- some workers idle or fail

With admission control:
- job waits
- nodes provision first
- job starts only when all 8 GPUs are ready

## Mental model
Admission control is the traffic light of the cluster:
- green → run
- yellow → wait
- red → reject

It protects both fairness and efficiency.

## Related terms
- [Queue](./queue.md)
- [ClusterQueue](./clusterqueue.md)
- [Priority Class](./priority-class.md)
- [Preemption](./preemption.md)
- [Gang Scheduling](./gang-scheduling.md)
- [Provisioning](./provisioning.md)
- [Admission Gating](./admission-gating.md)

