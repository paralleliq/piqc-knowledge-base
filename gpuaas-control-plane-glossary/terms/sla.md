# SLA

## Definition
SLA (Service Level Agreement) is a formal contract that defines the guaranteed level of service a platform commits to provide to a tenant or customer.

It specifies measurable targets such as availability, startup latency, capacity guarantees, and performance, along with consequences if those targets are not met.

In GPUaaS, an SLA defines what reliability and responsiveness the customer is paying for.

## Why it matters in GPUaaS
GPU platforms serve different tiers of users:

- production workloads
- training pipelines
- batch or best-effort jobs

Not all workloads require the same guarantees.

SLAs allow the platform to:
- differentiate service tiers
- prioritize important workloads
- justify pricing
- enforce fairness
- guide scaling and reclaim decisions

Without SLAs, all workloads are treated equally and critical jobs may be delayed.

## Common SLA dimensions

### Availability
- % uptime of the platform or service
- node readiness guarantees

### Startup latency
- time from request to running
- cold start limits

### Capacity guarantees
- reserved or minimum GPU count
- priority access during contention

### Performance
- throughput
- response time
- training completion windows

### Reliability
- job success rate
- failure recovery time

## Responsibilities
SLAs influence control plane behavior by:

- setting priority classes
- defining quotas or reservations
- triggering proactive scaling
- enabling reclaim/preemption
- generating alerts when breached

They convert business promises into technical policies.

## Example
Tenant A has an SLA:
- 99.9% availability
- ≤ 60s startup time
- guaranteed access to 10 H100 GPUs

If capacity is constrained:
- their jobs are prioritized
- lower-tier workloads may be reclaimed
- warm pools may be maintained

This ensures the SLA is met.

## SLA vs SLO
- **SLA** → contractual commitment to customers
- **SLO** → internal target used to achieve the SLA

SLOs help operators monitor and maintain SLA compliance.

## Mental model
An SLA is the promise the platform makes to customers about service quality and reliability.

The control plane’s job is to enforce that promise.

## Related terms
- [SLO](./slo.md)
- [Priority Class](./priority-class.md)
- [Quota](./quota.md)
- [Metrics](./metrics.md)
- [Alerting](./alerting.md)

