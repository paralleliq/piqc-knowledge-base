# Reconciliation Loop

## Definition
A reconciliation loop is a continuous control pattern where the system repeatedly compares the desired state with the actual state and takes corrective actions until they match.

It follows the cycle:

observe → compare → decide → act → repeat

This is the foundational pattern behind Kubernetes controllers and modern control planes.

## Why it matters in GPUaaS
GPU clusters are highly dynamic:
- jobs start and finish
- nodes scale up and down
- queues grow and shrink
- failures and interruptions occur

Because the system is constantly changing, one-time decisions are not sufficient. The platform must continuously re-evaluate reality and adjust.

A reconciliation loop allows the control plane to:
- maintain quotas and fairness
- restore capacity after failures
- react to queue backlogs
- reclaim idle GPUs
- optimize placement and cost
- enforce SLAs over time

Without reconciliation, the platform drifts away from policy and becomes inconsistent.

## Responsibilities
- collect current facts (capacity, utilization, queues, health)
- compare against policies and desired intent
- detect drift or violations
- compute corrective actions
- apply changes safely
- repeat on a fixed interval or events

## Typical triggers
- new workload submissions
- queue depth changes
- node readiness or failures
- utilization thresholds
- SLA/SLO violations
- periodic timers (e.g., every 1–5 minutes)

## Example
Desired state:
“Tenant A may use up to 10 GPUs.”

Actual state:
Tenant A is using 14 GPUs.

Reconciliation action:
Preempt or reclaim lower-priority workloads to return usage to 10.

## Mental model
The reconciliation loop keeps the system converging toward policy rather than relying on perfect initial decisions.

It is the core mechanism that turns a static configuration into an adaptive control plane.

## Related terms
- [Control Plane](./control-plane.md)
- [Governance Layer](./governance-layer.md)
- [Desired vs Actual State](./desired-vs-actual-state.md)
- [Actuation](./actuation.md)
- [Closed Loop Control](./closed-loop-control.md)

