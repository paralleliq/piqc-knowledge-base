# Scale Down

## Definition
Scale down is the process of reducing compute capacity by removing idle or underutilized resources such as pods, replicas, or nodes.

It is the opposite of scaling up.

In GPUaaS platforms, scale down answers:
“How can we safely remove unused GPUs to save cost?”

## Why it matters in GPUaaS
GPUs are expensive resources. Leaving unused nodes running leads directly to wasted money.

Common situations:

- batch jobs finish
- inference traffic drops overnight
- over-provisioning buffers remain unused
- tenants release capacity
- temporary spikes subside

Without scale down:
- utilization drops
- costs increase
- ROI suffers

Scale down keeps the fleet lean and efficient.

## Responsibilities
Scale-down mechanisms typically:

- detect idle or low-utilization nodes
- cordon nodes
- drain workloads safely
- terminate nodes
- consolidate workloads onto fewer machines
- maintain minimum capacity or buffers

It improves efficiency while protecting reliability.

## Typical behavior
1. workload demand decreases
2. nodes become idle or lightly used
3. autoscaler marks nodes for removal
4. node cordoned (no new pods)
5. workloads drained
6. node terminated

This happens gradually to avoid disruption.

## Example
Cluster:
- 50 GPUs during peak
- demand drops to 25 GPUs

Autoscaler:
- consolidates workloads
- drains idle nodes
- scales down to ~30 GPUs
- keeps buffer for spikes

Costs drop while service remains healthy.

## Common triggers

### Utilization-based
GPU usage below threshold for a period

### Replica-based
Fewer pods needed (HPA scale down)

### Schedule-based
Off-hours or predictable low demand

### Policy-based
Cost optimization rules

These signals inform when it’s safe to shrink capacity.

## Risks
Aggressive scale down can cause:

- cold starts later
- increased provisioning latency
- eviction of active jobs
- SLA violations
- thrashing (scale down then immediately up)

Most systems use:
- buffers
- grace periods
- disruption budgets

to avoid instability.

## Scale down vs consolidation
- **Scale down** → remove excess capacity
- **Consolidation** → pack workloads tighter first, then remove nodes

Consolidation usually precedes scale down.

## Role in the control plane
The control plane may:

- define utilization targets
- set idle thresholds
- protect premium tiers
- maintain buffers/warm pools
- schedule safe maintenance windows
- trigger consolidation workflows

It balances cost savings with reliability.

## Mental model
Scale down is the “trim the excess” step — removing idle GPUs so you only pay for what you actually need.

## Related terms
- [Autoscaler](./autoscaler.md)
- [Consolidation](./consolidation.md)
- [Cordon](./cordon.md)
- [Drain](./drain.md)
- [Capacity Buffer](./capacity-buffer.md)
- [Utilization](./utilization.md)
- [Cost Optimization](./cost-optimization.md)
