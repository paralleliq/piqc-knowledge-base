# Metering

## Definition
Metering is the process of measuring and recording resource consumption over time for workloads, tenants, or services.

It produces the raw usage data that powers billing, chargeback, reporting, and optimization.

In GPUaaS platforms, metering answers:
“Who used what, and for how long?”

## Why it matters in GPUaaS
GPUs are expensive and shared across many tenants. Without accurate metering:

- costs cannot be attributed fairly
- chargeback is impossible
- optimization is blind
- overconsumption goes unnoticed
- planning is inaccurate

Metering provides visibility into how resources are actually used, which is critical for both business and operational decisions.

## Responsibilities
Metering systems typically:

- track resource usage over time
- attribute usage to tenants or projects
- aggregate and store usage data
- support reporting and dashboards
- feed billing or chargeback systems
- enable cost optimization analysis

It connects infrastructure usage to accountability.

## Typical measurements

### Compute
- GPU hours
- node uptime
- replica count over time
- pod runtime

### Performance
- utilization %
- throughput
- request volume

### Capacity
- reserved vs used GPUs
- queue wait time
- idle time

These signals help quantify real consumption.

## Typical behavior
1. workloads run on GPUs
2. metrics collected continuously
3. usage aggregated (hourly/daily/monthly)
4. records stored per tenant
5. used for:
   - billing
   - reporting
   - planning
   - optimization

Metering runs continuously in the background.

## Example
Tenant A:
- uses 5 H100 GPUs for 12 hours

Metered usage:
- 60 GPU-hours

This data feeds:
- chargeback ($/GPU-hour)
- utilization reports
- capacity planning

Without metering, costs would be guesswork.

## Metering vs Chargeback
- **Metering** → measure usage
- **Chargeback** → convert usage into cost

Metering provides the facts; chargeback applies pricing.

## Role in the control plane
The control plane may use metering to:

- enforce quotas
- detect anomalies
- optimize placement
- drive policy decisions
- trigger alerts
- support billing workflows

It provides both operational and financial intelligence.

## Mental model
Metering is the “usage counter” that tracks exactly how much of the GPU fleet each tenant consumes.

## Related terms
- [Chargeback](./chargeback.md)
- [Utilization](./utilization.md)
- [Cost Optimization](./cost-optimization.md)
- [Quota](./quota.md)
- [Capacity Planning](./capacity-planning.md)
