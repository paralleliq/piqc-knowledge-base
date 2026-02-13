# Chargeback

## Definition
Chargeback is the practice of allocating infrastructure costs to tenants or teams based on their actual resource consumption.

It ties usage directly to cost responsibility, ensuring each tenant pays for what they use.

In GPUaaS, chargeback answers:
“Who consumed these GPU hours, and how much should they pay?”

## Why it matters in GPUaaS
GPUs are expensive resources. Without chargeback:

- costs are hidden or centralized
- overconsumption goes unchecked
- teams lack incentives to optimize
- capacity planning becomes inaccurate
- budgets are unpredictable

When usage is visible and billed:
- behavior improves
- waste decreases
- fairness increases
- spending aligns with value

Chargeback creates economic accountability.

## Responsibilities
Chargeback systems typically:

- measure resource consumption
- attribute usage to tenants or projects
- calculate costs
- generate reports or invoices
- integrate with billing systems
- provide visibility dashboards

It connects technical metrics to financial outcomes.

## Typical measurements
Common billing dimensions include:

- GPU hours consumed
- GPU type or shape (H100 vs T4 pricing)
- node uptime
- storage usage
- network usage
- reserved capacity
- premium tier surcharges

Different shapes or tiers may have different rates.

## Typical behavior
1. metrics track per-tenant usage
2. usage aggregated periodically (hourly/daily/monthly)
3. pricing rules applied
4. cost reports or invoices generated

This may be automated or integrated with finance tools.

## Example
Tenant A:
- uses 10 H100 GPUs for 24 hours

Usage:
- 240 GPU-hours

If rate = $3/hour:
- charge = $720

This makes cost explicit and predictable.

## Benefits
Chargeback encourages:

- right-sizing workloads
- releasing idle resources
- fewer abandoned jobs
- better scheduling efficiency
- realistic budgeting

It often improves utilization naturally.

## Chargeback vs Showback
- **Chargeback** → actual billing or internal cost transfer
- **Showback** → reporting only (no billing)

Many platforms start with showback, then move to chargeback.

## Mental model
Chargeback is the “meter and bill” system that connects GPU usage to financial accountability.

## Related terms
- [Metering](./metering.md)
- [Utilization](./utilization.md)
- [Cost Optimization](./cost-optimization.md)
- [Quota](./quota.md)
- [Tenant Onboarding](./tenant-onboarding.md)
