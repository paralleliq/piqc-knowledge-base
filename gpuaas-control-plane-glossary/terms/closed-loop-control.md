# Closed Loop Control

## Definition
Closed-loop control is an operating model where the system continuously observes its current state, compares it to desired outcomes, and automatically takes corrective actions to reduce the gap.

It follows a feedback cycle:

measure → evaluate → act → repeat

This is the foundational control pattern behind modern cloud control planes and Kubernetes controllers.

## Why it matters in GPUaaS
GPU platforms are highly dynamic:

- workloads start and finish constantly
- utilization fluctuates
- nodes fail
- queues grow and shrink
- demand shifts between tenants

Static configuration cannot keep the system efficient or reliable.

Closed-loop control enables the platform to automatically adapt in real time to maintain:
- utilization targets
- fairness
- SLAs/SLOs
- cost efficiency
- capacity balance

Without feedback, the system drifts and performance degrades.

## Responsibilities
A closed-loop system typically:

- collect metrics and events
- detect drift or violations
- evaluate policies
- compute corrective actions
- apply changes
- verify results
- repeat continuously

It replaces manual intervention with automation.

## Typical signals
Common inputs include:

- queue depth
- GPU utilization
- pending workloads
- node readiness
- SLA breaches
- cost anomalies

These trigger automated responses such as scaling, reclaim, or consolidation.

## Typical actions
Examples of control actions:

- provision nodes
- scale down idle capacity
- rebalance pools
- preempt lower-priority jobs
- gate admissions
- reroute traffic

Each action pushes the system back toward desired state.

## Example
Desired:
Maintain 75–85% GPU utilization.

Observed:
Utilization drops to 40%.

Closed-loop response:
- consolidate nodes
- scale down excess capacity

Utilization returns to target automatically.

## Relationship to other concepts
Closed-loop control combines:

- **Metrics** (sensing)
- **Policies** (decision logic)
- **Actuation** (enforcement)
- **Reconciliation loops** (continuous execution)

Together they form an autonomous control plane.

## Closed-loop vs open-loop
- **Closed-loop** → reacts to feedback (adaptive)
- **Open-loop** → executes fixed actions without feedback (static)

GPU platforms require closed-loop behavior due to constant change.

## Mental model
Closed-loop control is like a thermostat: measure temperature, compare to target, adjust heating — continuously.

The control plane does the same for GPUs.

## Related terms
- [Reconciliation Loop](./reconciliation-loop.md)
- [Desired vs Actual State](./desired-vs-actual-state.md)
- [Metrics](./metrics.md)
- [Actuation](./actuation.md)
- [Policy Engine](./policy-engine.md)
