# SLO

## Definition
SLO (Service Level Objective) is an internal, measurable target that defines the expected performance or reliability of a system.

It represents the operational goals engineers aim to achieve in order to meet customer-facing SLAs.

If an SLA is the promise to customers, an SLO is the engineering target used to keep that promise.

## Why it matters in GPUaaS
GPU platforms must balance:

- cost efficiency
- utilization
- responsiveness
- reliability

Without concrete targets, it is impossible to know:
- when to scale
- when to alert
- when to optimize
- whether the system is healthy

SLOs provide measurable thresholds that drive automation and operations.

They guide how the control plane behaves.

## Common SLO types

### Startup latency
- job start ≤ 60s
- inference scale-up ≤ 10s

### Availability
- 99.9% cluster uptime
- ≤ 0.1% failed jobs

### Capacity
- ≥ 95% admission success
- ≤ 5% queue wait time

### Utilization
- 70–85% average GPU utilization
- ≤ 10% idle nodes

### Reliability
- node recovery ≤ 2 minutes
- provisioning success ≥ 99%

## Responsibilities
SLOs are used to:

- trigger alerts
- drive scaling decisions
- inform reconciliation loops
- evaluate health
- prioritize remediation
- track performance trends

They convert high-level goals into actionable metrics.

## Typical behavior
If an SLO is violated:
1. alert fires
2. control plane reacts (scale, reclaim, provision)
3. or operators investigate

Example:
Queue wait time exceeds SLO → trigger proactive scaling.

## Example
Internal SLO:
- 95% of jobs start within 60 seconds

If startup latency increases:
- add warm capacity
- provision earlier
- adjust policies

This helps maintain the external SLA.

## SLO vs SLA
- **SLA** → external contract with customers
- **SLO** → internal engineering target
- **SLI** → metric used to measure SLO

SLOs operationalize SLAs.

## Mental model
An SLO is the performance target the platform continuously monitors and optimizes against.

It tells the control plane when action is needed.

## Related terms
- [SLA](./sla.md)
- [Metrics](./metrics.md)
- [Alerting](./alerting.md)
- [Reconciliation Loop](./reconciliation-loop.md)
- [Queue Depth](./queue-depth.md)

