# Workload Admission

## Definition
Workload admission is the process of deciding whether, when, and under what conditions a submitted workload is allowed to run on the cluster.

It determines if a workload should be accepted, delayed, prioritized, or rejected based on policies, capacity, and constraints.

In GPUaaS platforms, workload admission answers:
“Can this job run now?”

## Why it matters in GPUaaS
GPU resources are scarce and expensive:

- many tenants compete
- workloads request multiple GPUs
- provisioning is slow
- SLAs differ by tier

If all workloads are admitted immediately:

- queues explode
- partial starts occur
- idle ranks waste GPUs
- premium jobs get delayed
- costs increase

Admission control protects stability, fairness, and business priorities.

## Responsibilities
Workload admission systems typically:

- validate requests
- enforce quotas and limits
- check capacity availability
- prioritize workloads
- apply tier policies
- gate or queue jobs
- reject invalid or oversized requests

It is the gatekeeper between intent and execution.

## Typical behavior
1. workload submitted
2. admission checks run:
   - quota available?
   - capacity ready?
   - policy satisfied?
   - priority respected?
3. decision:
   - admit → schedule
   - queue → wait
   - reject → return error

Only safe workloads proceed to execution.

## Example
Tenant requests 8 GPUs.

Cluster has:
- only 4 free

Admission system:
- keeps job queued
- triggers provisioning
- admits only after all 8 are ready

This avoids partial starts and idle ranks.

## Common checks

### Resource checks
- GPU count available
- memory limits
- placement constraints

### Policy checks
- tenant tier
- fairness rules
- reservations
- cost limits

### Operational checks
- provisioning readiness
- node health
- disruption windows

All must pass before admission.

## Admission vs scheduling
- **Admission** → decide if/when workload can run
- **Sched**
